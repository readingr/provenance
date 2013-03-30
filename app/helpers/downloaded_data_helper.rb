module DownloadedDataHelper

	def prov(dd)
		return "<link rel=\"http://www.w3.org/ns/prov#hasProvenance\" href=\"#{ENV['PROV_SERVER']}/store/bundles/#{dd.prov_id}.provn\">
		<link rel=\"http://www.w3.org/ns/prov#hasAnchor\" href=\"target-URI\">
		<meta name=\"green-turtle-rdfa-message\">".html_safe
	end

	def display_microlink(dd)

		if dd.data_provider_user.micropost? 
			ActionController::Base.helpers.link_to('Post Micropost', post_micropost_data_provider_user_downloaded_datum_path(dd.data_provider_user.id, dd)) + " |"
		end
	end



end