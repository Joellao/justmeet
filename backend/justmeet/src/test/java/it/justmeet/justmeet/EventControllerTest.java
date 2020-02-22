package it.justmeet.justmeet;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
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
import static org.junit.Assert.assertEquals;
import static org.hamcrest.Matchers.hasSize;

import it.justmeet.justmeet.models.Category;
import it.justmeet.justmeet.models.Event;
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
public class EventControllerTest {

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
        Event event = new Event("TestEvent", "Macerata", "Test Descrizione", new Date(), true, Category.CINEMA, 8);
        User user = new User("DhSAxAaAMXZgmZyLrT96tgSDObD3", "joellao", "Asdrubale", "Barca", "asd@asd.com", new Date(),
                        1);

        @Test
        public void createEvent() throws Exception {
                Mockito.when(eventRepo.save(event)).thenReturn(event);
                Mockito.when(abstractRepo.findByUid("DhSAxAaAMXZgmZyLrT96tgSDObD3")).thenReturn(user);
                Map<String, String> map = new HashMap<String, String>();
                map.put("name", "Prova evento");
                map.put("description", "Prova evento");
                map.put("maxNumbers", "3");
                map.put("location", "Prova ");
                map.put("date", "20/04/2021");
                map.put("isFree", "true");
                map.put("category", "CINEMA");
                String json = new ObjectMapper().writeValueAsString(map);
                mvc.perform(MockMvcRequestBuilders.post("/event/").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON).content(json))
                                .andExpect(MockMvcResultMatchers.status().isOk());
        }

        @Test
        public void getEvent() throws Exception {
                Mockito.when(eventRepo.findById(1L)).thenReturn(Optional.of(event));
                mvc.perform(MockMvcRequestBuilders.get("/event/1").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON))
                                .andExpect(MockMvcResultMatchers.status().isOk());
        }

        @Test
        public void getEventNoToken() throws Exception {
                Mockito.when(eventRepo.findById(1L)).thenReturn(Optional.of(event));
                mvc.perform(MockMvcRequestBuilders.get("/event/1").contentType(MediaType.APPLICATION_JSON))
                                .andExpect(MockMvcResultMatchers.status().isForbidden());
        }

        @Test
        public void addComment() throws Exception {
                Mockito.when(eventRepo.findById(1L)).thenReturn(Optional.of(event));
                Map<String, String> map = new HashMap<String, String>();
                map.put("body", "Prova commento");
                String json = new ObjectMapper().writeValueAsString(map);

                mvc.perform(MockMvcRequestBuilders.post("/event/1/comment").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON).content(json))
                                .andExpect(MockMvcResultMatchers.status().isOk())
                                .andExpect(MockMvcResultMatchers.jsonPath("$.body", is(map.get("body"))));
        }

        @Test
        public void addReview() throws Exception {
                Mockito.when(eventRepo.findById(1L)).thenReturn(Optional.of(event));
                Map<String, String> map = new HashMap<String, String>();
                map.put("body", "Prova recensione");
                map.put("body", "Prova recensione");
                String json = new ObjectMapper().writeValueAsString(map);

                mvc.perform(MockMvcRequestBuilders.post("/event/1/comment").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON).content(json))
                                .andExpect(MockMvcResultMatchers.status().isOk())
                                .andExpect(MockMvcResultMatchers.jsonPath("$.body", is(map.get("body"))));
        }

        @Test
        public void prenote() throws Exception {
                Date date = new SimpleDateFormat("dd/MM/yyyy").parse("01/01/2025");
                Event event = new Event("TestEvent", "Macerata", "Test Descrizione", date, true, Category.CINEMA, 8);
                Mockito.when(eventRepo.findById(1L)).thenReturn(Optional.of(event));
                Mockito.when(userRepo.findByUid(user.getUid())).thenReturn(user);
                mvc.perform(MockMvcRequestBuilders.post("/event/1/prenote").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON))
                                .andExpect(MockMvcResultMatchers.status().isOk())
                                .andExpect(MockMvcResultMatchers.content().string("true"));
        }

        @Test
        public void cancelEvent() throws Exception {
                Event evento2 = event;
                evento2.setUser(user);
                Mockito.when(eventRepo.findById(1L)).thenReturn(Optional.of(evento2));
                Mockito.when(userRepo.findByUid(user.getUid())).thenReturn(user);
                mvc.perform(MockMvcRequestBuilders.patch("/event/1/").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON))
                                .andExpect(MockMvcResultMatchers.status().isOk())
                                .andExpect(MockMvcResultMatchers.content().string("true"));
        }

        @Test
        public void cancelPrenote() throws Exception {
                Date date = new SimpleDateFormat("dd/MM/yyyy").parse("01/01/2025");
                Event event = new Event("TestEvent", "Macerata", "Test Descrizione", date, true, Category.CINEMA, 8);
                event.setUser(user);
                Mockito.when(eventRepo.findById(1L)).thenReturn(Optional.of(event));
                Mockito.when(userRepo.findByUid(user.getUid())).thenReturn(user);
                mvc.perform(MockMvcRequestBuilders.patch("/event/1/").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON))
                                .andExpect(MockMvcResultMatchers.status().isOk())
                                .andExpect(MockMvcResultMatchers.content().string("true"));
        }

        @Test
        public void getNearMeMap() throws Exception {
                Date date = new SimpleDateFormat("dd/MM/yyyy").parse("01/01/2025");
                Event event = new Event("TestEvent", "Macerata", "Test Descrizione", date, true, Category.CINEMA, 8);
                Event event2 = new Event("TestEvent2", "San Severino Marche", "Test Descrizione", date, true,
                                Category.CINEMA, 8);
                Event event3 = new Event("TestEvent3", "Taccoli", "Test Descrizione", date, true, Category.CINEMA, 8);
                Event event4 = new Event("TestEvent4", "Pollenza", "Test Descrizione", date, true, Category.CINEMA, 8);
                List<Long> ids = new ArrayList<Long>();
                List<Event> events = new ArrayList<Event>();
                ids.add(1L);
                ids.add(2L);
                ids.add(3L);
                ids.add(4L);
                ids.add(5L);
                events.add(event);
                events.add(event2);
                events.add(event3);
                events.add(event4);
                Mockito.when(eventRepo.findByLatAndLon(3, 4, 5)).thenReturn(ids);
                Mockito.when(eventRepo.findAllById(ids)).thenReturn(events);
                User user = new User("DhSAxAaAMXZgmZyLrT96tgSDObD3", "joellao", "Asdrubale", "Barca", "asd@asd.com",
                                new Date(), 1);
                Mockito.when(userRepo.findByUid(user.getUid())).thenReturn(user);
                mvc.perform(MockMvcRequestBuilders.get("/event/map").param("latitude", "3").param("longitude", "4")
                                .param("raggio", "5").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON))
                                .andExpect(MockMvcResultMatchers.status().isOk())
                                .andExpect(MockMvcResultMatchers.jsonPath("$", hasSize(4)));
        }

        @Test
        public void modifyEvent() throws Exception {
                Event evento2 = event;
                evento2.setUser(user);
                Mockito.when(eventRepo.findById(1L)).thenReturn(Optional.of(evento2));
                Map<String, String> map = new HashMap<String, String>();
                map.put("name", "Prova evento");
                map.put("description", "Prova evento");
                map.put("maxNumbers", "3");
                map.put("location", "Prova ");
                map.put("date", "20/04/2021");
                map.put("isFree", "true");
                map.put("category", "CINEMA");
                String json = new ObjectMapper().writeValueAsString(map);
                mvc.perform(MockMvcRequestBuilders.put("/event/1").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON).content(json))
                                .andExpect(MockMvcResultMatchers.status().isOk())
                                .andExpect(MockMvcResultMatchers.jsonPath("$.name", is(map.get("name"))));
        }

        @Test
        public void findEvent() throws Exception {
                Date date = new SimpleDateFormat("dd/MM/yyyy").parse("01/01/2025");
                Event event = new Event("TestEvent", "Macerata", "Test Descrizione", date, true, Category.CINEMA, 8);
                Event event2 = new Event("TestEvent", "Macerata", "Test Descrizione", date, true, Category.CINEMA, 8);
                List<Event> events = new ArrayList<Event>();
                events.add(event);
                events.add(event2);

                Mockito.when(eventRepo.findAll()).thenReturn(events);
                mvc.perform(MockMvcRequestBuilders.get("/event/eventName/find").header("Authorization", idToken)
                                .contentType(MediaType.APPLICATION_JSON))
                                .andExpect(MockMvcResultMatchers.status().isOk());
                assertEquals(events.size(), 2);
        }

}