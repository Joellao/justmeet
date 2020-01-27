package it.justmeet.justmeet;

import org.junit.jupiter.api.extension.BeforeAllCallback;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import static org.junit.jupiter.api.extension.ExtensionContext.Namespace.GLOBAL;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;

public class Extension implements BeforeAllCallback, ExtensionContext.Store.CloseableResource {

    private static boolean started = false;
    public static String idToken;

    @Override
    public void beforeAll(ExtensionContext context)
            throws JsonMappingException, JsonProcessingException, FirebaseAuthException {
        if (!started) {
            started = true;
            // Your "before all tests" startup logic goes here
            // The following line registers a callback hook when the root test context is
            // shut down
            context.getRoot().getStore(GLOBAL).put("any unique name", this);
            try {
                FirebaseOptions options = new FirebaseOptions.Builder()
                        .setCredentials(GoogleCredentials.fromStream(
                                new ClassPathResource("/justmeet-ea052-firebase-adminsdk-hqpog-acfd828f0b.json")
                                        .getInputStream()))
                        .setStorageBucket("justmeet-ea052.appspot.com")
                        .setDatabaseUrl("https://justmeet-ea052.firebaseio.com/").build();
                FirebaseApp.initializeApp(options);
            } catch (IOException e) {
                e.printStackTrace();
            }
            String token = FirebaseAuth.getInstance().createCustomToken("DhSAxAaAMXZgmZyLrT96tgSDObD3");
            RestTemplate t = new RestTemplate();
            Map<String, String> map = new HashMap<String, String>();
            map.put("token", token);
            map.put("returnSecureToken", "true");
            try {
                ResponseEntity<String> response = t.postForEntity(
                        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=AIzaSyDF0V8-WK52yY_HKsoar4D0NBkY2zvn-pQ",
                        map, String.class);
                ObjectMapper mapper = new ObjectMapper();
                JsonNode root = mapper.readTree(response.getBody());
                JsonNode name = root.path("idToken");
                String nameText = name.asText();
                idToken = nameText.substring(0, nameText.length());
            } catch (HttpClientErrorException e) {
                System.out.println(e.getResponseBodyAsString());
            }
        }
    }

    @Override
    public void close() {
        // Your "after all tests" logic goes here
    }
}