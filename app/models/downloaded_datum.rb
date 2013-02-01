class DownloadedDatum < ActiveRecord::Base
  attr_accessible :annotation, :data, :name, :data_provider_user_id
  belongs_to :data_provider_user


  def generate_provenance
  	#use self.


    debugger


    # bundle= {"wasDerivedFrom"=>{"_:id6"=>{"prov:usedEntity"=>"tr:WD-prov-dm-20111018", "prov:generatedEntity"=>"tr:WD-prov-dm-20111215"}}, "wasAssociatedWith"=>{"_:id8"=>{"prov:plan"=>"pr:rec-advance", "prov:agent"=>"_:id7", "prov:activity"=>"ex:act1"}, "_:id10"=>{"prov:plan"=>"pr:rec-advance", "prov:agent"=>"_:id9", "prov:activity"=>"ex:act2"}}, "used"=>{"_:id5"=>{"prov:entity"=>"ar3:0111", "prov:activity"=>"ex:act2"}, "_:id4"=>{"prov:entity"=>"ar2:0141", "prov:activity"=>"ex:act1"}, "_:id3"=>{"prov:entity"=>"ar1:0004", "prov:activity"=>"ex:act1"}}, "agent"=>{"_:id7"=>{}, "_:id9"=>{}}, "entity"=>{"w3:Consortium"=>{"prov:type"=>"Organization"}, "ar2:0141"=>{"prov:type"=>["http://www.w3.org/2005/08/01-transitions.html#pubreq", "xsd:anyURI"]}, "ar3:0111"=>{"prov:type"=>["http://www.w3.org/2005/08/01-transitions.html#pubreq", "xsd:anyURI"]}, "tr:WD-prov-dm-20111215"=>{"prov:type"=>["pr:RecsWD", "xsd:QName"]}, "ar1:0004"=>{"prov:type"=>["http://www.w3.org/2005/08/01-transitions.html#transreq", "xsd:anyURI"]}, "tr:WD-prov-dm-20111018"=>{"prov:type"=>["pr:RecsWD", "xsd:QName"]}, "pr:rec-advance"=>{"prov:type"=>["prov:Plan", "xsd:QName"]}}, "prefix"=>{"pr"=>"http://www.w3.org/2005/10/Process-20051014/tr.html#", "ar1"=>"https://lists.w3.org/Archives/Member/chairs/2011OctDec/", "ar2"=>"https://lists.w3.org/Archives/Member/w3c-archive/2011Oct/", "ar3"=>"https://lists.w3.org/Archives/Member/w3c-archive/2011Dec/", "tr"=>"http://www.w3.org/TR/2011/", "w3"=>"http://www.w3.org/", "ex"=>"http://example.org/"}, "activity"=>{"ex:act1"=>{"prov:type"=>"publish"}, "ex:act2"=>{"prov:type"=>"publish"}}, "wasGeneratedBy"=>{"_:id1"=>{"prov:entity"=>"tr:WD-prov-dm-20111018", "prov:activity"=>"ex:act1"}, "_:id2"=>{"prov:entity"=>"tr:WD-prov-dm-20111215", "prov:activity"=>"ex:act2"}}} 


    # take out of here and put in seperate action/module so we can reuse for other data provider users.
    bundle = {"prefix"=>{"ex"=>"http://localhost:3000"}, 
    "entity"=>{"ex:fb1"=>{}, "ex:fb2"=>{}}, 
    "agent"=>{"ex:system"=>{}}, 
    "activity"=>{"ex:download1"=>{"prov:type"=>"Download 1"}, "ex:download2"=>{"prov:type"=>"Download 2"}},
    "wasAssociatedWith"=>{"_:asoc1"=>{"prov:agent"=>"ex:system", "prov:activity"=> "ex:download1"},"_:asoc2"=>{"prov:agent"=>"ex:system", "prov:activity"=> "ex:download2"}},
    "wasGeneratedBy"=>{"_:gen1"=>{"prov:entity"=>"ex:fb1", "prov:activity"=>"ex:download1"}, "_:gen2"=>{"prov:entity"=>"ex:fb2", "prov:activity"=> "ex:download2"}},
    "wasDerivedFrom"=>{"_:der1"=>{"prov:usedEntity"=>"ex:fb1", "prov:generatedEntity"=>"ex:fb2"}}
    } 

    # rec_id = "some useful name"
    rec_id = self.name + "-" + self.id.to_s

    # test = ProvRequests.post_request(current_user.prov_username, current_user.access_token, bundle, rec_id)
    prov_json_results = ProvRequests.post_request(self.data_provider_user.user.prov_username, self.data_provider_user.user.access_token, bundle, rec_id)
    # puts prov_json_results
    # puts "*****************"
    prov_hash_results = ActiveSupport::JSON.decode(prov_json_results)

    self.prov_id = prov_hash_results["id"]
    self.save
  end



end