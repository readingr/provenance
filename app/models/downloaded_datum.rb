class DownloadedDatum < ActiveRecord::Base
  attr_accessible :annotation, :data, :name, :data_provider_user_id
  belongs_to :data_provider_user


  #this generates the provenance from the data passed in. This is done like this because it doesn't require a user logged in.
    def generate_provenance(cron)
        require 'ProvRequests'
        require 'json'
        require 'active_support/core_ext/hash/deep_merge'


        dd = DownloadedDatum.where(data_provider_user_id: self.data_provider_user_id)


        #select the second last downloaded data. This is so we can use the 
        if dd.count >= 2
          #perhaps pass all the data to them so if one doesn't have provenance, it can use the next one??
          last_downloaded_data = dd.order("created_at DESC").limit(1).offset(1).first
        end

        #data provider name
        data_provider_name = self.data_provider_user.data_provider.name


        #should it be ex:Facebook-64 or should I just keep it as ex:64?
        if last_downloaded_data.nil?
            new_bundle = {
                "prefix"=> {
                    "ex"=> "http://localhost:3000" #change to sensible url
                }, 
                "entity"=>{
                    "#{data_provider_name}#{self.id.to_s}:bundle"=>{
                        "prov:type"=> "prov:Bundle"
                    }
                },
                "wasAttributedTo"=> {
                    "_:attr#{self.id.to_s}"=>{
                        "prov:entity"=> "#{data_provider_name}#{self.id.to_s}:bundle", 
                        "prov:agent"=> "#{self.agent}"
                    }
                },
                "agent"=>{
                    "#{data_provider_user.user.first_name}"=>{

                    }
                },
                # "actedOnBehalfOf"=>{
                #     "_:id#{self.id.to_s}"=>{
                #         "prov:delegate"=> "a2",
                #         "prov:responsible"=> "a1"
                #     }
                # },
                # "wasRevisionOf"=>{

                # },
                # "specializationOf"=>{
                #     "_:spec#{self.id.to_s}"=>{
                #         "prov:specificEntity"=>"#{self.agent}",
                #         "prov:generalEntity"=>"#{data_provider_user.user.first_name}"
                #     }
                # },
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
                                "prov:type"=>"Download #{self.id}"
                            }
                        },

                        "specializationOf"=>{
                            "_:spec#{self.id.to_s}"=>{
                                "prov:specificEntity"=>"ex:#{self.id.to_s}",
                                "prov:generalEntity"=>"ex:#{data_provider_name}"
                            }
                        },
                        "wasGeneratedBy"=>{
                            "_:gen2"=>{
                                "prov:entity"=>"ex:#{self.id.to_s}",
                                "prov:activity"=> "ex:download#{self.id.to_s}"
                            }
                        },
                    }
                }
            }

            # debugger
        else
            bundle = {
                "prefix"=> {
                    "ex"=> "http://localhost:3000" #change to sensible url
                }, 
                "entity"=>{
                    "#{data_provider_name}#{self.id.to_s}:bundle"=>{
                        "prov:type"=> "prov:Bundle"
                    }
                },
                "specializationOf"=>{
                    "_:spec#{self.id.to_s}"=>{
                        "prov:specificEntity"=>"ex:#{self.id.to_s}",
                        "prov:generalEntity"=>"ex:#{data_provider_name}"
                    }
                },
                "wasDerivedFrom"=> {
                    "_:der#{self.id.to_s}"=> {
                        "prov:usedEntity"=> "#{data_provider_name}#{last_downloaded_data.id.to_s}:bundle",
                        "prov:generatedEntity"=> "#{data_provider_name}#{self.id.to_s}:bundle"
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
                                "prov:type"=>"Download #{self.id.to_s}"
                            }
                        },

                        "specializationOf"=>{
                            "_:spec#{self.id.to_s}"=>{
                                "prov:specificEntity"=>"ex:#{self.id.to_s}",
                                "prov:generalEntity"=>"ex:#{data_provider_name}"
                            }
                        },
                        
                        "wasGeneratedBy"=>{
                            "_:gen#{self.id.to_s}"=>{
                                "prov:entity"=>"ex:#{self.id.to_s}",
                                "prov:activity"=> "ex:download#{self.id.to_s}"
                            }
                        },
                    }
                }
            } 

            #if it's a cron job then make it a proxy
            if cron
                att =  {
                        "wasAttributedTo"=> {
                            "_:attr#{self.id.to_s}"=>{
                                "prov:agent"=> "#{self.agent} Proxy",
                                "prov:entity"=> "#{data_provider_name}#{self.id.to_s}:bundle"
                            }
                        },
                        "actedOnBehalfOf"=>{
                            "_:aobo#{self.id.to_s}"=>{
                                "prov:delegate"=> "#{self.agent} Proxy",
                                "prov:responsible"=> "#{self.agent}"
                            }
                        }
                     }
            else
                att =  {
                        "wasAttributedTo"=> {
                            "_:attr#{self.id.to_s}"=>{
                                "prov:agent"=> "#{self.agent}",
                                "prov:entity"=> "#{data_provider_name}#{self.id.to_s}:bundle"
                            }
                        }
                     }                    
            end

            bundle = att.deep_merge(bundle)

            # if cron
            #     bbc = {
            #         "actedOnBehalfOf"=>{
            #             "_:aobo#{self.id.to_s}"=>{
            #                 "prov:delegate"=> "#{self.agent} Proxy",
            #                 "prov:responsible"=> "#{self.agent}"
            #             }
            #         }
            #     }
            #     bundle = bbc.deep_merge(bundle)

            # end

            #download the the provenance from the last user
            downloaded_prov = ProvRequests.get_request(self.data_provider_user.user.prov_username, self.data_provider_user.user.access_token, last_downloaded_data.prov_id)

            #parse the json
            if !downloaded_prov.blank?
                old_prov = ActiveSupport::JSON.decode(downloaded_prov)["prov_json"]
            end

            if !old_prov.nil?
                #deep merge them together
                new_bundle = old_prov.deep_merge(bundle)
            else
                #if there is no old prov, use the bundle itself
                new_bundle = bundle
            end
        end


        rec_id = self.name + "-" + self.id.to_s

        #send the request to the prov web service
        prov_json_results = ProvRequests.post_request(self.data_provider_user.user.prov_username, self.data_provider_user.user.access_token, new_bundle, rec_id)


        #if the results are blank, typically means 401 so destroy self
        if prov_json_results.blank?
            self.destroy
            raise "Error, probably an incorrect access token"
        end
        prov_hash_results = ActiveSupport::JSON.decode(prov_json_results)

        self.prov_id = prov_hash_results["id"]
        self.save
    end

    #this will return the agents name. I.e. "richard-2013-2-1" or "richard-2013-2-1-proxy"
    def agent
        return self.data_provider_user.user.first_name+" "+self.data_provider_user.user.current_sign_in_at.to_s
        # return "AGENT"
    end
end