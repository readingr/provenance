class DownloadedDatum < ActiveRecord::Base
  attr_accessible :data, :name, :data_provider_user_id
  belongs_to :data_provider_user


  #this generates the provenance from the data passed in. This is done like this because it doesn't require a user logged in.
    def generate_provenance(cron)
        require 'ProvRequests'
        require 'json'
        require 'active_support/core_ext/hash/deep_merge'


        dd = DownloadedDatum.where(data_provider_user_id: self.data_provider_user_id)

        #select the second last downloaded data. 
        if dd.count >= 2
          last_downloaded_data = dd.order("created_at DESC").limit(1).offset(1).first
        end

        #data provider name
        data_provider_name = self.data_provider_user.data_provider.name

        new_bundle = {
            "entity"=>{
                "#{data_provider_name}#{self.id.to_s}:bundle"=>{
                    "prov:type"=> "prov:Bundle"
                }
            },
            "agent"=>{
                "#{data_provider_user.user.first_name}"=>{},
                "#{self.agent}"=>{}
            },
            "specializationOf"=>{
                "spec#{self.agent}"=>{
                    "prov:specificEntity"=>"#{self.agent}",
                    "prov:generalEntity"=>"#{data_provider_user.user.first_name}"
                }
            },
            "bundle"=>{
                "#{data_provider_name}#{self.id.to_s}:bundle"=>{
                    "entity"=>{
                        "DownloadedData#{self.id.to_s}"=>{

                        }
                    }, 

                    "agent"=>{
                        "#{data_provider_name}Website"=>{

                        }
                    },
                    "activity"=>{
                        "Download#{self.id.to_s}"=>{
                            "startTime"=> ["#{strip_time(Time.now)}", "xsd:dateTime"],
                            #["2011-11-16T16:06:00", "xsd:dateTime"]
                            #it is assumed it takes one second
                            "endTime"=> ["#{strip_time(Time.now+1)}" , "xsd:dateTime"],
                            "prov:type"=>"Download #{self.id}"
                        }
                    },
                    "wasAssociatedWith"=>{
                        "bunassoc#{self.id.to_s}"=>{
                            "prov:activity"=> "Download#{self.id.to_s}",
                            "prov:agent"=> "#{data_provider_name}Website"
                        }
                    },
                    "wasGeneratedBy"=>{
                        "bungen#{self.id.to_s}"=>{
                            "prov:entity"=>"DownloadedData#{self.id.to_s}",
                            "prov:activity"=> "Download#{self.id.to_s}"
                        }
                    },
                }
            }
        } 


        if !last_downloaded_data.nil?
                der_bundle = {
                    "wasDerivedFrom"=> {
                        "der#{self.id.to_s}"=> {
                            "prov:usedEntity"=> "#{data_provider_name}#{last_downloaded_data.id.to_s}:bundle",
                            "prov:generatedEntity"=> "#{data_provider_name}#{self.id.to_s}:bundle",
                            "prov:type"=> "prov:Revision"
                        }
                    }
                }
                new_bundle = der_bundle.deep_merge(new_bundle)


            #if they've signed in more than once we can add revision!
            if !self.data_provider_user.user.last_sign_in_at.nil?
                revision = {
                    "agent"=>{
                        "#{self.data_provider_user.user.first_name}#{strip_time(self.data_provider_user.user.last_sign_in_at)}"=>{}
                    },
                    "wasDerivedFrom"=>{
                        "rev#{self.agent}"=>{
                            "prov:generatedEntity"=>"#{self.agent}",
                            "prov:usedEntity"=>"#{self.data_provider_user.user.first_name}#{strip_time(self.data_provider_user.user.last_sign_in_at)}",
                            "prov:type"=> "prov:Revision"
                        }
                    },
                    "specializationOf"=>{
                        "spec#{self.data_provider_user.user.first_name+""+strip_time(self.data_provider_user.user.last_sign_in_at)}"=>{
                            "prov:specificEntity"=>"#{self.data_provider_user.user.first_name+""+strip_time(self.data_provider_user.user.last_sign_in_at)}",
                            "prov:generalEntity"=>"#{data_provider_user.user.first_name}"
                        }
                    }
                }
                new_bundle = revision.deep_merge(new_bundle)
            end



            #download the the provenance from the last user
            downloaded_prov = ProvRequests.get_request(self.data_provider_user.user.prov_username, self.data_provider_user.user.prov_access_token, last_downloaded_data.prov_id)

            #parse the json
            if !downloaded_prov.blank?
                old_prov = ActiveSupport::JSON.decode(downloaded_prov)["prov_json"]
            end

            if !old_prov.nil?
                #deep merge them together
                new_bundle = old_prov.deep_merge(new_bundle)
            end

        end


        #if it's a cron job then make it a proxy
        if cron
            att =  {
                    "agent"=>{
                        "#{self.agent}Proxy"=>{}
                    },
                    "wasAttributedTo"=> {
                        "attr#{self.id.to_s}"=>{
                            "prov:agent"=> "#{self.agent}Proxy",
                            "prov:entity"=> "#{data_provider_name}#{self.id.to_s}:bundle"
                        }
                    },
                    "actedOnBehalfOf"=>{
                        "aobo#{self.agent}Proxy"=>{
                            "prov:delegate"=> "#{self.agent}Proxy",
                            "prov:responsible"=> "#{self.agent}"
                        }
                    }
                 }
        else
            att =  {
                    "wasAttributedTo"=> {
                        "attr#{self.id.to_s}"=>{
                            "prov:agent"=> "#{self.agent}",
                            "prov:entity"=> "#{data_provider_name}#{self.id.to_s}:bundle"
                        }
                    }
                 }                    
        end
        new_bundle = att.deep_merge(new_bundle)

        

        if !ActiveSupport::JSON.decode(self.data)['data'].blank?
            mp = ActiveSupport::JSON.decode(self.data)['data']['has_provenance']
            if !mp.blank?
                prov_id = /(\d*)\.provn/.match(mp)
                if !prov_id.nil?


                    prov_id = prov_id[1]

                    if !prov_id.blank?
                        downloaded_prov = ProvRequests.get_request(self.data_provider_user.user.prov_username, self.data_provider_user.user.prov_access_token, prov_id)
                      
                        if !downloaded_prov.blank?
                            old_prov = ActiveSupport::JSON.decode(downloaded_prov)["prov_json"]

                            #if micropost - code above is there if system is extended in the future.
                            if self.data_provider_user.micropost?
                                id_no = ActiveSupport::JSON.decode(self.data)['data']['id']
                                derived_from = {
                                    "wasDerivedFrom"=>{
                                        "rev#{self.agent}#{id_no}#{self.id.to_s}"=>{
                                            "prov:generatedEntity"=>"#{data_provider_name}#{self.id.to_s}:bundle",
                                            "prov:usedEntity"=>"ex:Micropost#{id_no}"
                                        }
                                    }
                                }

                                new_bundle =new_bundle.deep_merge(derived_from)
                            end
                            new_bundle = new_bundle.deep_merge(old_prov)
                        end 
                    end
                end
            end
        end

        # puts new_bundle.to_json


        rec_id = self.name + "-" + self.id.to_s

        puts new_bundle.to_json


        #send the request to the prov web service
        prov_json_results = ProvRequests.post_request(self.data_provider_user.user.prov_username, self.data_provider_user.user.prov_access_token, new_bundle, rec_id)


        #if the results are blank, typically means 401 so destroy self
        if prov_json_results.blank?
            self.destroy
            raise "Error, probably an incorrect access token"
        end
        prov_hash_results = ActiveSupport::JSON.decode(prov_json_results)

        self.prov_id = prov_hash_results["id"]
        self.save


        return new_bundle
    end

    #this will return the agents name. I.e. "richard2013-04-08T14:35:39"
    def agent
        return self.data_provider_user.user.first_name+""+strip_time(self.data_provider_user.user.current_sign_in_at)
    end


    #this strips a time object to a prov correct string
    def strip_time(time)

        #split the time into an array.
        timeArray = time.to_s.split(/\s/)
        return timeArray[0]+"T"+timeArray[1]

    end




end