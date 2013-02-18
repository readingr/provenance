module DownloadedDataHelper

	def prov(dd)
		return "<link rel=\"http://www.w3.org/ns/prov#hasProvenance\" href=\"https://provenance.ecs.soton.ac.uk/store/bundles/#{dd.prov_id}.provn\">
		<link rel=\"http://www.w3.org/ns/prov#hasAnchor\" href=\"target-URI\">
		<meta name=\"green-turtle-rdfa-message\">".html_safe
	end
end
