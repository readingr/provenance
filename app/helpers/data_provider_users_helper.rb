module DataProviderUsersHelper

	def update_link(dpu)

		#if the dataprovider user is facebook return that code
		if(dpu.facebook? or dpu.twitter?)
			return "<td><a href=\"/data_provider_users/#{dpu.id.to_s}/update_data\">Update</a></td>".html_safe
		end
	end


	def last_updated_time(dpu)

	    if !dpu.downloaded_datum.blank?
	    	return "<td> #{dpu.downloaded_datum.last.updated_at} </td>".html_safe
	    else
	    	return '<td>N/A</td>'.html_safe
	    end
	end



end
