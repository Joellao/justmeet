package it.justmeet.justmeet;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import static org.hamcrest.Matchers.is;

import it.justmeet.justmeet.models.Announcement;
import it.justmeet.justmeet.models.Category;

import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.repositories.AbstractUserRepository;
import it.justmeet.justmeet.models.repositories.AnnouncementRepository;
import it.justmeet.justmeet.models.repositories.CommentRepository;
import it.justmeet.justmeet.models.repositories.EventRepository;
import it.justmeet.justmeet.models.repositories.InstitutionRepository;
import it.justmeet.justmeet.models.repositories.PhotoRepository;
import it.justmeet.justmeet.models.repositories.ReportProblemRepository;
import it.justmeet.justmeet.models.repositories.ReviewRepository;
import it.justmeet.justmeet.models.repositories.SegnalazioneCommentoRepository;
import it.justmeet.justmeet.models.repositories.UserRepository;

@WebMvcTest
@ExtendWith({ Extension.class })
public class AnnouncementControllerTest {

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
        @MockBean
        ReportProblemRepository repProbRepo;

        static String idToken = Extension.idToken;
        private User user = new User("DhSAxAaAMXZgmZyLrT96tgSDObD3", "joellao", "Asdrubale", "Barca", "asd@asd.com",
                        new Date(), 1);
        private Announcement announce = new Announcement("announce", "descrizione", user, Category.CINEMA, new Date());

        @Test
        public void getAnnouncement() throws Exception {
                Mockito.when(announcementRepo.findById(1L)).thenReturn(Optional.of(announce));
                mvc.perform(MockMvcRequestBuilders.get("/announcement/1").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON))
                                .andExpect(MockMvcResultMatchers.status().isOk());
        }

        @Test
        public void getAnnouncementNoToken() throws Exception {
                Mockito.when(announcementRepo.findById(1L)).thenReturn(Optional.of(announce));
                mvc.perform(MockMvcRequestBuilders.get("/announcement/1").contentType(MediaType.APPLICATION_JSON))
                                .andExpect(MockMvcResultMatchers.status().isForbidden());
        }

        @Test
        public void addComment() throws Exception {
                Mockito.when(announcementRepo.findById(1L)).thenReturn(Optional.of(announce));
                Map<String, String> map = new HashMap<String, String>();
                map.put("body", "Prova commento");
                String json = new ObjectMapper().writeValueAsString(map);

                mvc.perform(MockMvcRequestBuilders.post("/announcement/1/comment").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON).content(json))
                                .andExpect(MockMvcResultMatchers.status().isOk())
                                .andExpect(MockMvcResultMatchers.jsonPath("$.body", is(map.get("body"))));
        }

        @Test
        public void createAnnouncement() throws Exception {
                Mockito.when(announcementRepo.save(announce)).thenReturn(announce);
                Map<String, String> map = new HashMap<String, String>();
                map.put("name", "Prova annuncio");
                map.put("description", "Prova annuncio");
                map.put("category", "CINEMA");
                String json = new ObjectMapper().writeValueAsString(map);
                mvc.perform(MockMvcRequestBuilders.post("/announcement/").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON).content(json))
                                .andExpect(MockMvcResultMatchers.status().isOk());
        }

        @Test
        public void modifyAnnounce() throws Exception {
                Mockito.when(announcementRepo.findById(1L)).thenReturn(Optional.of(announce));
                Map<String, String> map = new HashMap<String, String>();
                map.put("name", "prova");
                map.put("description", "Prova annuncio");
                map.put("category", "CINEMA");
                String json = new ObjectMapper().writeValueAsString(map);
                mvc.perform(MockMvcRequestBuilders.put("/announcement/1").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON).content(json))
                                .andExpect(MockMvcResultMatchers.status().isOk())
                                .andExpect(MockMvcResultMatchers.jsonPath("$.name", is(map.get("name"))));
        }

}