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
import static org.hamcrest.Matchers.hasSize;

import it.justmeet.justmeet.models.Category;
import it.justmeet.justmeet.models.Comment;
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
public class CommentControllerTest {

    @Autowired
    MockMvc mvc;
    @MockBean
    UserRepository userRepo;
    @MockBean
    AbstractUserRepository abstractRepo;
    @MockBean
    AnnouncementRepository announcementRepo;
    @MockBean
    CommentRepository commentRepo;
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
    private Comment comment = new Comment("body", user, new Date());

    @Test
    public void modifyComment() throws Exception {
        Mockito.when(commentRepo.findById(1L)).thenReturn(Optional.of(comment));
        Map<String, String> map = new HashMap<String, String>();
        map.put("body", "prova");
        String json = new ObjectMapper().writeValueAsString(map);
        mvc.perform(MockMvcRequestBuilders.put("/comment/1").header("Authorization", idToken)
                .contentType(MediaType.APPLICATION_JSON).content(json)).andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.body", is(map.get("body"))));
    }

}