package it.justmeet.justmeet.controllers;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import it.justmeet.justmeet.models.creates.EventCreate;
import it.justmeet.justmeet.models.creates.ReviewCreate;
import it.justmeet.justmeet.models.repositories.EventRepository;
import it.justmeet.justmeet.models.repositories.PhotoRepository;
import it.justmeet.justmeet.models.repositories.ReviewRepository;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.config.WoWoUtility;
import it.justmeet.justmeet.models.AbstractUser;
import it.justmeet.justmeet.models.repositories.UserRepository;
import it.justmeet.justmeet.models.Comment;
import it.justmeet.justmeet.models.creates.CommentCreate;
import it.justmeet.justmeet.models.repositories.CommentRepository;
import it.justmeet.justmeet.models.Event;
import it.justmeet.justmeet.models.Photo;
import it.justmeet.justmeet.models.Review;
import it.justmeet.justmeet.models.RispostaLocation;

import org.springframework.web.bind.annotation.PutMapping;

/**
 * Responsabilità: coordina le azioni che si possono eseguire in un evento
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */
@RestController
public class EventController {
	@Autowired
	UserRepository userRepo; // jpa è una libreria
	@Autowired
	EventRepository eventRepo; // per collegare il database con il codice
	@Autowired
	CommentRepository commentRepo; //
	@Autowired
	ReviewRepository reviewRepo;

	@Autowired
	PhotoRepository photoRepo;

	/**
	 * Metodo che mi permette di avere tutti gli eventi
	 * 
	 * @return
	 */
	@GetMapping("event")
	public List<Event> getEvents() {
		return eventRepo.findAll();
	}

	/**
	 * metodo che mi permette di creare un nuovo evento
	 * 
	 * @param event
	 * @param token
	 * @return l'evento creato
	 * @throws FirebaseAuthException
	 * @throws ParseException
	 * @throws UnsupportedEncodingException
	 * @throws RestClientException
	 * @throws JsonProcessingException
	 * @throws JsonMappingException
	 */
	@PostMapping("/event")
	public Event createEvent(@RequestBody EventCreate event, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException, ParseException, RestClientException, UnsupportedEncodingException,
			JsonMappingException, JsonProcessingException {
		FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
		String userId = check.getUid();
		AbstractUser user = userRepo.findByUid(userId);
		Date date = new SimpleDateFormat("dd/MM/yyyy").parse(event.getDate());
		Event evento = new Event(event.getName(), event.getLocation(), event.getDescription(), date, event.isFree(),
				event.getCategory(), event.getMaxPersons());
		if (user.isCanCreatePublicEvent()) {
			evento.setPublicEvent(true);
		} else {
			evento.setPublicEvent(false);
		}

		RestTemplate r = new RestTemplate();

		ResponseEntity<List<RispostaLocation>> rateResponse = r.exchange(
				"https://eu1.locationiq.com/v1/search.php?key=18f98769274079&q="
						+ URLEncoder.encode(event.getLocation(), "UTF-8") + "&format=json",
				HttpMethod.GET, null, new ParameterizedTypeReference<List<RispostaLocation>>() {
				});
		List<RispostaLocation> list = rateResponse.getBody();
		evento.setLatitude(Double.parseDouble(list.get(0).getLat()));
		evento.setLongitude(Double.parseDouble(list.get(0).getLon()));
		evento.setUser(user);
		eventRepo.save(evento);
		user.addEvent(evento);
		userRepo.save(user);

		return evento;
	}

	/**
	 * metodo che grazie alla chiamata get mi permette di visualizzare l'evento in
	 * base al suo id di riconoscimento
	 * 
	 * @param eventId
	 * @return l'id dell'evento selezionato
	 */
	@GetMapping("/event/{eventId}")
	public Event getEvent(@PathVariable("eventId") Long eventId) {
		// Chiamata al databse con eventId per avere le info dell'evento
		// return new Event(eventId, null, eventId, eventId, false, eventId, 0);
		Event event = eventRepo.findById(eventId).get();
		return event;
	}

	/**
	 * metodo che mi permette di modificare un evento
	 * 
	 * @param eventId
	 * @param event
	 * @return l'evento modificato
	 * @throws FirebaseAuthException
	 * @throws ParseException
	 */
	@PutMapping(value = "/event/{eventId}")
	public Event modifyEvent(@PathVariable("eventId") Long eventId, @RequestBody EventCreate event,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException, ParseException {
		// Chiamata al database per aggiornare l'evento con i nuovi dati
		// return new Event(eventId, null, eventId, eventId, false, eventId, 0);
		Event evento = eventRepo.findById(eventId).get();
		if (!evento.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			return null;
		}
		Date date = new SimpleDateFormat("dd/MM/yyyy").parse(event.getDate());
		evento.setName(event.getName());
		evento.setDate(date);
		evento.setLocation(event.getLocation());
		evento.setFree(event.isFree());
		evento.setCategory(event.getCategory());
		evento.setMaxNumber(event.getMaxPersons());
		eventRepo.save(evento);
		return evento;
	}

	/**
	 * metodo che mi permette di eliminare l'evento
	 * 
	 * @param eventId
	 * @throws FirebaseAuthException
	 */
	@DeleteMapping("/event/{eventId}")
	public void deleteEvent(@PathVariable("eventId") Long eventId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		// Cancella dal databse eventId
		Event evento = eventRepo.findById(eventId).get();
		if (!evento.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			return;
		}
		eventRepo.delete(evento);
	}

	/**
	 * metodo che mi permette di annullare l'evento
	 * 
	 * @param eventId
	 */
	@PatchMapping("/event/{eventId}")
	public void cancelEvent(@PathVariable("eventId") Long eventId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		Event evento = eventRepo.findById(eventId).get();
		if (!evento.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			return;
		}
		evento.setCancelled(true);
		eventRepo.save(evento);
	}

	/**
	 * metodo che mi permete di aggiungere un commento all'evento
	 * 
	 * @param comment
	 * @param eventId
	 * @param token
	 * @return l'evento con il commento
	 * @throws FirebaseAuthException
	 */
	@PostMapping("/event/{eventId}/comment")
	public Comment addComment(@RequestBody CommentCreate comment, @PathVariable("eventId") Long eventId,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
		String userId = check.getUid();
		AbstractUser user = userRepo.findByUid(userId);
		Event event = eventRepo.findById(eventId).get();
		Comment c = new Comment(comment.getBody(), user, new Date(), false);
		event.addComment(c);
		eventRepo.save(event);
		return c;
	}

	/**
	 * metodo che mi permette selezionato l'evento, di aggiungere una recensione
	 * all'evento
	 * 
	 * @param review
	 * @param eventId
	 * @param token
	 * @return l'evento con la relativa recensione
	 * @throws FirebaseAuthException
	 */
	@PostMapping("/event/{eventId}/review")
	public Review addReview(@RequestBody ReviewCreate review, @PathVariable("eventId") Long eventId,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
		String userId = check.getUid();
		User user = (User) userRepo.findByUid(userId);
		Event event = eventRepo.findById(eventId).get();
		Review r = new Review(user, event, review.getBody(), review.getStars(), new Date());
		event.addReview(r);
		eventRepo.save(event);
		return r;
	}

	@PostMapping("/event/{eventId}/prenote")
	public boolean prenote(@PathVariable("eventId") Long eventId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
		String userId = check.getUid();
		User user = (User) userRepo.findByUid(userId);
		Event event = eventRepo.findById(eventId).get();
		if (event.getPartecipants().size() == event.getMaxNumber()) {
			return false;
		}
		event.addPartecipant(user);
		user.partecipateEvent(event);
		userRepo.save(user);
		eventRepo.save(event);
		return true;
	}

	@PatchMapping("/event/{eventId}/cancelPrenote")
	public boolean cancelPrenote(@PathVariable("eventId") Long eventId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
		String userId = check.getUid();
		User user = (User) userRepo.findByUid(userId);
		Event evento = eventRepo.findById(eventId).get();
		if (user.getPartecipatedEvents().contains(evento)) {
			user.getPartecipatedEvents().remove(evento);
			evento.getPartecipants().remove(user);
			userRepo.save(user);
			eventRepo.save(evento);
			return true;
		}
		return false;
	}

	@PostMapping("/event/{eventId}/photo")
	public Photo addPhoto(@RequestHeader("Authorization") String token, @RequestParam("photo") MultipartFile file,
			@PathVariable("eventId") Long eventId) throws Exception {
		FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
		String userId = check.getUid();
		if (file.isEmpty()) {
			throw new Exception("File vuoto");
		}
		try {
			// Get the file and save it somewhere
			byte[] bytes = file.getBytes();
			String url = WoWoUtility.getPhotoUrl(file.getOriginalFilename(), bytes);
			Event event = eventRepo.findById(eventId).get();
			Photo photo = new Photo(url, userRepo.findByUid(userId), new Date());
			event.addPhoto(photo);
			photoRepo.save(photo);
			eventRepo.save(event);
			return new Photo(url);
		} catch (IOException e) {
			e.printStackTrace();
		}
		// Chiamata al databse per aggiungere una foto
		return null;

	}

	@GetMapping("/event/{eventName}/find")
	public List<Event> findEvent(@PathVariable("eventName") String eventName,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
		String userId = check.getUid();
		List<Event> result = eventRepo.findAll().stream().filter(event -> eventName.equals(event.getName()))
				.collect(Collectors.toList());
		return result;
	}

}