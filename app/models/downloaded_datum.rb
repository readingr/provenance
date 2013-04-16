class DownloadedDatum < ActiveRecord::Base
  attr_accessible :data, :name, :data_provider_user_id
  belongs_to :data_provider_user


  #this generates the provenance from the data passed in. This is done like this because it doesn't require a user logged in.
    def generate_provenance(cron)
        require 'ProvRequests'
        require 'json'
        require 'active_support/core_ext/hash/deep_merge'


        dd = DownloadedDatum.where(data_provider_user_id: self.data_provider_user_id)
        #*****************

        #remove whitespace at some point: http://stackoverflow.com/questions/1634750/ruby-function-to-remove-all-white-spaces
        #get has_provenance at some point.
        #change prov_id to has_provenance location, makes much more sense, or put both. Up to you.

        #*****************

        #select the second last downloaded data. 
        if dd.count >= 2
          last_downloaded_data = dd.order("created_at DESC").limit(1).offset(1).first
        end

        #data provider name
        data_provider_name = self.data_provider_user.data_provider.name


        #should it be ex:Facebook-64 or should I just keep it as ex:64?
        # if last_downloaded_data.nil?
        #     new_bundle = {
        #         "prefix"=> {
        #             "ex"=> "http://localhost:3000" #change to sensible url
        #         }, 
        #         "entity"=>{
        #             "#{data_provider_name}#{self.id.to_s}:bundle"=>{
        #                 "prov:type"=> "prov:Bundle"
        #             },
        #             "ex:#{self.agent}"=>{},
        #             "#{data_provider_user.user.first_name}"=>{}
        #         },
        #         "wasAttributedTo"=> {
        #             "ex:attr#{self.id.to_s}"=>{
        #                 "prov:entity"=> "#{data_provider_name}#{self.id.to_s}:bundle", 
        #                 "prov:agent"=> "#{self.agent}"
        #             }
        #         },
        #         "specializationOf"=>{
        #             "ex:spec#{self.agent}"=>{
        #                 "prov:specificEntity"=>"ex:#{self.agent}",
        #                 "prov:generalEntity"=>"#{data_provider_user.user.first_name}"
        #             }
        #         },
        #         "bundle"=>{
        #             "#{data_provider_name}#{self.id.to_s}:bundle"=>{
        #                 "entity"=>{
        #                     "ex:#{self.id.to_s}"=>{

        #                         },
        #                     "ex:#{data_provider_name}"=>{

        #                     }
        #                 }, 
        #                 "activity"=>{
        #                     "ex:download#{self.id.to_s}"=>{
        #                         "startTime"=> ["#{strip_time(Time.now)}", "xsd:dateTime"],
        #                         #["2011-11-16T16:06:00", "xsd:dateTime"]
        #                         #it is assumed it takes one second
        #                         "endTime"=> ["#{strip_time(Time.now+1)}" , "xsd:dateTime"],
        #                         "prov:type"=>"Download #{self.id}"
        #                     }
        #                 },

        #                 "specializationOf"=>{
        #                     "ex:spec#{self.id.to_s}"=>{
        #                         "prov:specificEntity"=>"ex:#{self.id.to_s}",
        #                         "prov:generalEntity"=>"ex:#{data_provider_name}"
        #                     }
        #                 },
        #                 "wasGeneratedBy"=>{
        #                     "ex:gen#{self.id.to_s}"=>{
        #                         "prov:entity"=>"ex:#{self.id.to_s}",
        #                         "prov:activity"=> "ex:download#{self.id.to_s}"
        #                     }
        #                 },
        #             }
        #         }
        #     }
        # else
        new_bundle = {
            "prefix"=> {
                "ex"=> "http://localhost:3000" 
            }, 
            "entity"=>{
                "#{data_provider_name}#{self.id.to_s}:bundle"=>{
                    "prov:type"=> "prov:Bundle"
                },
                "ex:#{self.agent}"=>{},
                "#{data_provider_user.user.first_name}"=>{}
            },
            "specializationOf"=>{
                "ex:spec#{self.agent}"=>{
                    "prov:specificEntity"=>"ex:#{self.agent}",
                    "prov:generalEntity"=>"#{data_provider_user.user.first_name}"
                }
            },
            "bundle"=>{
                "#{data_provider_name}#{self.id.to_s}:bundle"=>{
                    "entity"=>{
                        "ex:#{self.id.to_s}"=>{

                            },
                        "ex:#{data_provider_name}"=>{

                        }
                    }, 

                    "activity"=>{
                        "ex:download#{self.id.to_s}"=>{
                            "startTime"=> ["#{strip_time(Time.now)}", "xsd:dateTime"],
                            #["2011-11-16T16:06:00", "xsd:dateTime"]
                            #it is assumed it takes one second
                            "endTime"=> ["#{strip_time(Time.now+1)}" , "xsd:dateTime"],
                            "prov:type"=>"Download #{self.id}"
                        }
                    },

                    "specializationOf"=>{
                        "ex:spec#{self.id.to_s}"=>{
                            "prov:specificEntity"=>"ex:#{self.id.to_s}",
                            "prov:generalEntity"=>"ex:#{data_provider_name}"
                        }
                    },
                    
                    "wasGeneratedBy"=>{
                        "ex:gen#{self.id.to_s}"=>{
                            "prov:entity"=>"ex:#{self.id.to_s}",
                            "prov:activity"=> "ex:download#{self.id.to_s}"
                        }
                    },
                }
            }
        } 


        if !last_downloaded_data.nil?
            # if !self.data_provider_user.micropost?
                der = {
                    "wasDerivedFrom"=> {
                        "ex:der#{self.id.to_s}"=> {
                            "prov:usedEntity"=> "#{data_provider_name}#{last_downloaded_data.id.to_s}:bundle",
                            "prov:generatedEntity"=> "#{data_provider_name}#{self.id.to_s}:bundle",
                            "prov:type"=> "prov:Revision"
                        }
                    }
                }
                new_bundle = der.deep_merge(new_bundle)


            #if they've signed in more than once we can add revision!
            if !self.data_provider_user.user.last_sign_in_at.nil?
                revision = {
                    "wasDerivedFrom"=>{
                        "ex:rev#{self.agent}"=>{
                            "prov:generatedEntity"=>"ex:#{self.data_provider_user.user.first_name}#{strip_time(self.data_provider_user.user.current_sign_in_at)}",
                            "prov:usedEntity"=>"ex:#{self.data_provider_user.user.first_name}#{strip_time(self.data_provider_user.user.last_sign_in_at)}",
                            "prov:type"=> "prov:Revision"
                        }
                    },
                    "specializationOf"=>{
                        "ex:spec#{self.data_provider_user.user.first_name+""+strip_time(self.data_provider_user.user.last_sign_in_at)}"=>{
                            "prov:specificEntity"=>"ex:#{self.data_provider_user.user.first_name+""+strip_time(self.data_provider_user.user.last_sign_in_at)}",
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
            else
                #if there is no old prov, use the bundle itself
            end

        end


        #if it's a cron job then make it a proxy
        if cron
            att =  {
                    "wasAttributedTo"=> {
                        "ex:attr#{self.id.to_s}"=>{
                            "prov:agent"=> "#{self.agent}Proxy",
                            "prov:entity"=> "#{data_provider_name}#{self.id.to_s}:bundle"
                        }
                    },
                    "actedOnBehalfOf"=>{
                        "ex:aobo#{self.agent}Proxy"=>{
                            "prov:delegate"=> "#{self.agent}Proxy",
                            "prov:responsible"=> "#{self.agent}"
                        }
                    }
                 }
        else
            att =  {
                    "wasAttributedTo"=> {
                        "ex:attr#{self.id.to_s}"=>{
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
                  # debugger

                  if !prov_id.blank?
                    downloaded_prov = ProvRequests.get_request(self.data_provider_user.user.prov_username, self.data_provider_user.user.prov_access_token, prov_id)
                  
                    if !downloaded_prov.blank?
                        old_prov = ActiveSupport::JSON.decode(downloaded_prov)["prov_json"]

                        if self.data_provider_user.micropost?
                            id_no = ActiveSupport::JSON.decode(self.data)['data']['id']
                            derived_from = {
                                "wasDerivedFrom"=>{
                                    "ex:rev#{self.agent}#{id_no}#{self.id.to_s}"=>{
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

        puts new_bundle.to_json


        rec_id = self.name + "-" + self.id.to_s

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