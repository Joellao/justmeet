package it.justmeet.justmeet;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.fail;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import antlr.debug.Event;

import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.hasSize;

import it.justmeet.justmeet.models.AbstractUser;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.repositories.AbstractUserRepository;
import it.justmeet.justmeet.models.repositories.AnnouncementRepository;
import it.justmeet.justmeet.models.repositories.CommentRepository;
import it.justmeet.justmeet.models.repositories.EventRepository;
import it.justmeet.justmeet.models.repositories.InstitutionRepository;
import it.justmeet.justmeet.models.repositories.PhotoRepository;
import it.justmeet.justmeet.models.repositories.ReviewRepository;
import it.justmeet.justmeet.models.repositories.SegnalazioneCommentoRepository;
import it.justmeet.justmeet.models.repositories.UserRepository;

@WebMvcTest
public class UserControllerTest {

    @Autowired
    MockMvc mvc;
    @MockBean
    UserRepository userRepo;
    @MockBean
    AbstractUserRepository abstractRepo;
    @MockBean
    AnnouncementRepository announcementRepo;
    @MockBean
    CommentRepository commnetRepo;
    @MockBean
    InstitutionRepository instRepo;
    @MockBean
    EventRepository eventRepo;
    @MockBean
    PhotoRepository photoRepo;
    @MockBean
    SegnalazioneCommentoRepository sglRepo;
    @MockBean
    ReviewRepository revRepo;

    static String idToken;

    @org.junit.jupiter.api.BeforeAll
    public static void beforeAllTestMethods() throws Exception {
        try {
            FirebaseOptions options = new FirebaseOptions.Builder().setCredentials(GoogleCredentials.fromStream(
                    new ClassPathResource("/justmeet-ea052-firebase-adminsdk-hqpog-acfd828f0b.json").getInputStream()))
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

    @Test
    public void getUserWithoutToken() throws Exception {
        AbstractUser user = new User("DhSAxAaAMXZgmZyLrT96tgSDObD3", "joellao", "Asdrubale", "Barca", "asd@asd.com",
                new Date(), 1);
        Mockito.when(abstractRepo.findByUid(user.getUid())).thenReturn(user);
        mvc.perform(MockMvcRequestBuilders.get("/user").contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.status().isForbidden());
    }

    @Test
    public void getUser() throws Exception {
        AbstractUser user = new User("DhSAxAaAMXZgmZyLrT96tgSDObD3", "joellao", "Asdrubale", "Barca", "asd@asd.com",
                new Date(), 1);
        Mockito.when(abstractRepo.findByUid(user.getUid())).thenReturn(user);
        mvc.perform(MockMvcRequestBuilders.get("/user").header("Authorization", idToken)
                .contentType(MediaType.APPLICATION_JSON)).andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    public void getProfileNotExisting() throws Exception {
        Mockito.when(abstractRepo.findByUid("nonEsistente")).thenReturn(null);
        mvc.perform(MockMvcRequestBuilders.get("/user/nonEsistente").header("Authorization", idToken)
                .contentType(MediaType.APPLICATION_JSON)).andExpect(MockMvcResultMatchers.status().isNotFound());
    }

    @Test
    public void getProfileExisting() throws Exception {
        User user = new User("uidEsistente", "mario.rossi", "Mario", "Rossi", "asd@asd.com", new Date(), 1);
        Mockito.when(userRepo.findByUid(user.getUid())).thenReturn(user);
        mvc.perform(MockMvcRequestBuilders.get("/user/uidEsistente").header("Authorization", idToken)
                .contentType(MediaType.APPLICATION_JSON)).andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    public void modifyOwnProfile() throws Exception {
        AbstractUser user = new User("DhSAxAaAMXZgmZyLrT96tgSDObD3", "joellao", "Asdrubale", "Barca", "asd@asd.com",
                new Date(), 1);
        Mockito.when(abstractRepo.findByUid(user.getUid())).thenReturn(user);
        Map<String, String> map = new HashMap<String, String>();
        map.put("username", "prova");
        map.put("email", "prova");
        map.put("profileImage", "prova");
        map.put("bio", "prova");
        String json = new ObjectMapper().writeValueAsString(map);
        mvc.perform(MockMvcRequestBuilders.put("/user/DhSAxAaAMXZgmZyLrT96tgSDObD3").header("Authorization", idToken)
                .contentType(MediaType.APPLICATION_JSON).content(json)).andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.userName", is(map.get("username"))));
    }

    @Test
    public void modifyOtherProfile() throws Exception {
        Map<String, String> map = new HashMap<String, String>();
        map.put("username", "prova");
        map.put("email", "prova");
        map.put("profileImage", "prova");
        map.put("bio", "prova");
        String json = new ObjectMapper().writeValueAsString(map);
        User user = new User("uidEsistente", "mario.rossi", "Mario", "Rossi", "asd@asd.com", new Date(), 1);
        Mockito.when(abstractRepo.findByUid(user.getUid())).thenReturn(user);
        mvc.perform(MockMvcRequestBuilders.put("/user/uidEsistente").header("Authorization", idToken)
                .contentType(MediaType.APPLICATION_JSON).content(json))
                .andExpect(MockMvcResultMatchers.status().isForbidden());
    }

    @Test
    public void getEvents() throws Exception {
        User user = new User("uidEsistente", "mario.rossi", "Mario", "Rossi", "asd@asd.com", new Date(), 1);
        Mockito.when(abstractRepo.findByUid(user.getUid())).thenReturn(user);
        mvc.perform(MockMvcRequestBuilders.get("/user/uidEsistente/event").header("Authorization", idToken)
                .contentType(MediaType.APPLICATION_JSON)).andExpect(MockMvcResultMatchers.status().isOk());
        assertEquals(user.getEvents(), new ArrayList<Event>());
    }

}