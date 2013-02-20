module DownloadedDataHelper

	def prov(dd)
		return "<link rel=\"http://www.w3.org/ns/prov#hasProvenance\" href=\"http://127.0.0.1:8000/store/bundles/#{dd.prov_id}.provn\">
		<link rel=\"http://www.w3.org/ns/prov#hasAnchor\" href=\"target-URI\">
		<meta name=\"green-turtle-rdfa-message\">".html_safe
	end
end
