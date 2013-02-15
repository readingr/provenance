class DownloadedDatum < ActiveRecord::Base
  attr_accessible :annotation, :data, :name, :data_provider_user_id
  belongs_to :data_provider_user


  #this generates the provenance from the data passed in. This is done like this because it doesn't require a user logged in.
    def generate_provenance
        require 'ProvRequests'
        require 'json'
        require 'active_support/core_ext/hash/deep_merge'


        dd = DownloadedDatum.where(data_provider_user_id: self.data_provider_user_id)


        #select the second last downloaded data. This is so we can use the 
        if dd.count >= 2
          #perhaps pass all the data to them so if one doesn't have provenance, it can use the next one??
          last_downloaded_data = dd.order("created_at DESC").limit(1).offset(1).first
        end


            #should it be ex:Facebook-64 or should I just keep it as ex:64?
            # debugger

        if last_downloaded_data.nil?
            new_bundle = {"prefix"=>{"ex"=>"http://localhost:3000"}, 
            "entity"=>{"ex:#{self.id}"=>{}, "ex:#{self.data_provider_user.data_provider.name}"=>{}}, 

            "agent"=>{"ex:system"=>{}}, 

            "activity"=>{"ex:download#{self.id}"=>{"prov:type"=>"Download #{self.id}"}},

            "specializationOf"=>{"_spec#{self.id}"=>{"prov:specificEntity"=>"ex:#{self.id}", "prov:generalEntity"=>"ex:#{self.data_provider_user.data_provider.name}"}},

            "wasAssociatedWith"=>{"_:asoc2"=>{"prov:agent"=>"ex:system", "prov:activity"=> "ex:download#{self.id}"}},
            
            "wasGeneratedBy"=>{"_:gen2"=>{"prov:entity"=>"ex:#{self.id}", "prov:activity"=> "ex:download#{self.id}"}},

            }

            # debugger
        else
            # take out of here and put in seperate action/module so we can reuse for other data provider users.
            bundle = {"prefix"=>{"ex"=>"http://localhost:3000"}, 
            "entity"=>{"ex:#{last_downloaded_data.id}"=>{}, "ex:#{self.id}"=>{}, "ex:#{last_downloaded_data.data_provider_user.data_provider.name}"=>{}}, 

            "agent"=>{"ex:system"=>{}}, 

            "activity"=>{"ex:download#{last_downloaded_data.id}"=>{"prov:type"=>"Download #{last_downloaded_data.id}"}, "ex:download#{self.id}"=>{"prov:type"=>"Download #{self.id}"}},

            "specializationOf"=>{"_spec#{self.id}"=>{"prov:specificEntity"=>"ex:#{self.id}", "prov:generalEntity"=>"ex:#{self.data_provider_user.data_provider.name}"}},

            # "specializationOf"=>{"_spec#{last_downloaded_data.id}"=>{"prov:generalEntity" => "ex:#{last_downloaded_data.data_provider_user.data_provider.name}", "prov:specificEntity"=>"ex:#{self.id}"}},

            "wasAssociatedWith"=>{"_:asoc2"=>{"prov:agent"=>"ex:system", "prov:activity"=> "ex:download#{self.id}"}},
            
            "wasGeneratedBy"=>{"_:gen2"=>{"prov:entity"=>"ex:#{self.id}", "prov:activity"=> "ex:download#{self.id}"}},

            "wasDerivedFrom"=>{"_:der1"=>{"prov:usedEntity"=>"ex:#{last_downloaded_data.id}", "prov:generatedEntity"=>"ex:#{self.id}"}}
            } 



            #download the the provenance for the last user
            downloaded_prov = ProvRequests.get_request(self.data_provider_user.user.prov_service.username, self.data_provider_user.user.prov_service.access_token, last_downloaded_data.prov_id)

            #parse the json
            old_prov = ActiveSupport::JSON.decode(downloaded_prov)["prov_json"]

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
        prov_json_results = ProvRequests.post_request(self.data_provider_user.user.prov_service.username, self.data_provider_user.user.prov_service.access_token, new_bundle, rec_id)
        # debugger

        #get the results of the hash
        prov_hash_results = ActiveSupport::JSON.decode(prov_json_results)

        self.prov_id = prov_hash_results["id"]
        self.save
    end
end