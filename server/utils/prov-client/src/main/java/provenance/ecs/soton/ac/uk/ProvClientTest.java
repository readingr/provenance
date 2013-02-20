package provenance.ecs.soton.ac.uk;

import org.apache.log4j.Logger;
import org.apache.wicket.request.flow.RedirectToUrlException;
import org.apache.wicket.request.mapper.parameter.PageParameters;
import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.markup.html.form.Form;
import org.apache.wicket.markup.html.form.TextField;
import org.apache.wicket.markup.html.WebPage;
import org.apache.wicket.model.PropertyModel;
import org.scribe.builder.ServiceBuilder;
import org.scribe.model.OAuthRequest;
import org.scribe.model.Response;
import org.scribe.model.Token;
import org.scribe.model.Verb;
import org.scribe.model.Verifier;
import org.scribe.oauth.OAuthService;


public class ProvClientTest extends WebPage {
	private static final long serialVersionUID = 1L;
	private static Logger logger = Logger.getLogger(ProvClientTest.class);
	
	private String url = ProvServer.HOST + "/api/v0/bundle/";
	private String provJSON = "{\"entity\": {\"e1\": {}}}";
	
	private Token requestToken = null;
	private Token accessToken = null;
	private transient OAuthService service = new ServiceBuilder().provider(ProvServer.class)
            .apiKey("a12818da2173418087dcc7646d70f0e5")
            .apiSecret("ZZfSRBwz6KPaNqxm")
            .scope("api")
            .callback("http://localhost:8080/") // return to this page when authorization finishes
            .build();
	
	private void getData() {
		// Step 5. Sign our data request with the access token
		OAuthRequest request = new OAuthRequest(Verb.GET, url);
		request.addHeader("Accept", "application/json");
		service.signRequest(accessToken, request);
		Response response = request.send();
		provJSON = response.getBody();
	}
	
	private String formatJSONRequest(String data) {
		String request = "{ \"rec_id\": \"post_test_java\", \"public\": \"True\",\"content\": " + data + "}";
		return request;
	}
	
	private void sendData() {
		// Step 5. Sign our data request with the access token
		OAuthRequest request = new OAuthRequest(Verb.POST, url);
		request.addHeader("Accept", "application/json");
		String payload = formatJSONRequest(provJSON);
		request.addPayload(payload);
		request.addHeader("Content-Length", Integer.toString(payload.length()));
		request.addHeader("Content-Type", "application/json");
		
		service.signRequest(accessToken, request);
		Response response = request.send();
		provJSON = response.getBody();
		logger.debug("HTTP Response Code:" + response.getCode());
	}
	
	/**
	 * Constructor.
	 */
    public ProvClientTest(final PageParameters parameters) {
		PropertyModel<String> urlModel = new PropertyModel<String>(this, "url");
		PropertyModel<String> provJSONModel = new PropertyModel<String>(this, "provJSON");
		
		// The label displays the PROV-JSON content
		add(new Label("json", provJSONModel));
		
		
		// Check if this is an authorised call back
		String oauth_verifier = parameters.get("oauth_verifier").toString();
		if (oauth_verifier != null && accessToken == null) {
			// It is
			if (requestToken == null) {
				// Retrieve the request token back from session store
				requestToken = (Token)getSession().getAttribute("oauth_request_token");
			}
			// Step 3. Create a verifier from the verifier code the server sent
			Verifier verifier = new Verifier(oauth_verifier);
			// Step 4. Exchange the request token for an access token
			accessToken = service.getAccessToken(requestToken, verifier);
//			getData();
			sendData();
		}
		
		Form<?> form = new Form<Void>("form") {
			private static final long serialVersionUID = 108549330230839160L;

			@Override
			protected void onSubmit() {
				if (accessToken == null) {
					// We don't have access right yet
					if (requestToken == null) {
						// We don't even have the requestToken
						// Step 1. Ask for the request token
						requestToken = service.getRequestToken();
						// requestToken will no longer be stored after page redirection
						// store it now for later use
						getSession().setAttribute("oauth_request_token", requestToken);
					}
					// Step 2. Ask for the authorization URL
					String authUrl = service.getAuthorizationUrl(requestToken);
					throw new RedirectToUrlException(authUrl);
				}
				else {
//					getData();
					sendData();
				}
			}
		};
		form.add(new TextField<String>("urlInput", urlModel));
		add(form);
    }    
}