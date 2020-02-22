package it.justmeet.justmeet.controllers;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import com.google.firebase.auth.FirebaseAuthException;

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
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import it.justmeet.justmeet.models.creates.EventCreate;
import it.justmeet.justmeet.models.creates.ReviewCreate;
import it.justmeet.justmeet.models.repositories.EventRepository;
import it.justmeet.justmeet.models.repositories.InstitutionRepository;
import it.justmeet.justmeet.models.repositories.PhotoRepository;
import it.justmeet.justmeet.models.repositories.ReviewRepository;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.config.WoWoUtility;
import it.justmeet.justmeet.exceptions.ForbiddenAccess;
import it.justmeet.justmeet.exceptions.InvalidDataException;
import it.justmeet.justmeet.models.AbstractUser;
import it.justmeet.justmeet.models.repositories.UserRepository;
import it.justmeet.justmeet.models.Comment;
import it.justmeet.justmeet.models.creates.CommentCreate;
import it.justmeet.justmeet.models.repositories.AbstractUserRepository;
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
	AbstractUserRepository abstractRepo; // jpa è una libreria
	@Autowired
	UserRepository userRepo; // jpa è una libreria
	@Autowired
	InstitutionRepository instRepo; // jpa è una libreria
	@Autowired
	EventRepository eventRepo; // per collegare il database con il codice
	@Autowired
	CommentRepository commentRepo; //
	@Autowired
	ReviewRepository reviewRepo;

	@Autowired
	PhotoRepository photoRepo;

	/**
	 * metodo che mi permette di creare un nuovo evento
	 * 
	 * @param event
	 * @param token
	 * @return l'evento creato
	 * @throws Exception
	 */
	@PostMapping("/event")
	public Event createEvent(@RequestBody EventCreate event, @RequestHeader("Authorization") String token)
			throws Exception {
		String userId = WoWoUtility.getInstance().getUid(token);
		AbstractUser user = abstractRepo.findByUid(userId);
		Date date = new SimpleDateFormat("dd/MM/yyyy").parse(event.getDate());
		WoWoUtility.getInstance().validateDateEvent(date);
		if (event.getName() == null && event.getLocation() == null && event.getDescription() == null
				&& event.getCategory() == null) {
			throw new Exception("Devi compilare i campi che mancano");
		}
		Event evento = new Event(event.getName(), event.getLocation(), event.getDescription(), date, event.isFree(),
				event.getCategory(), event.getMaxPersons());
		if (user.getType() == 2) {
			evento.setPublicEvent(true);
		} else {
			evento.setPublicEvent(false);
			if (event.getMaxPersons() > 100) {
				throw new Exception("Non puoi creare un evento con più di 100 persone");
			}
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
		abstractRepo.save(user);

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
		return eventRepo.findById(eventId).get();

	}

	/**
	 * metodo che mi permette di modificare un evento
	 * 
	 * @param eventId
	 * @param event
	 * @return l'evento modificato
	 * @throws FirebaseAuthException
	 * @throws ParseException
	 * @throws InvalidDataException
	 */
	@PutMapping(value = "/event/{eventId}")
	public Event modifyEvent(@PathVariable("eventId") Long eventId, @RequestBody EventCreate event,
			@RequestHeader("Authorization") String token)
			throws FirebaseAuthException, ParseException, InvalidDataException {
		// Chiamata al database per aggiornare l'evento con i nuovi dati
		// return new Event(eventId, null, eventId, eventId, false, eventId, 0);
		Event evento = eventRepo.findById(eventId).get();
		if (!evento.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			throw new ForbiddenAccess("Stai cercando di modificare un evento non tuo");
		}
		Date date = new SimpleDateFormat("dd/MM/yyyy").parse(event.getDate());
		WoWoUtility.getInstance().validateDateEvent(date);
		evento.setName(event.getName());
		evento.setDate(date);
		evento.setDescription(event.getDescription());
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
	public boolean deleteEvent(@PathVariable("eventId") Long eventId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		// Cancella dal databse eventId
		Event evento = eventRepo.findById(eventId).get();
		if (!evento.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			throw new ForbiddenAccess("Stai cercando di eliminare un evento non tuo");
		}
		try {
			eventRepo.delete(evento);
			return true;
		} catch (IllegalArgumentException e) {
		}
		return false;
	}

	/**
	 * metodo che mi permette di annullare l'evento
	 * 
	 * @param eventId
	 */
	@PatchMapping("/event/{eventId}")
	public boolean cancelEvent(@PathVariable("eventId") Long eventId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		Event evento = eventRepo.findById(eventId).get();
		if (!evento.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			throw new ForbiddenAccess("Non puoi annullare un evento non tuo");
		}
		try {
			evento.setCancelled(true);
			eventRepo.save(evento);
			return true;
		} catch (Exception e) {
		}
		return false;
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
		String userId = WoWoUtility.getInstance().getUid(token);
		AbstractUser user = abstractRepo.findByUid(userId);
		Event event = eventRepo.findById(eventId).get();
		Comment c = new Comment(comment.getBody(), user, new Date());
		Comment savedComment = commentRepo.save(c);
		event.addComment(savedComment);
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
		String userId = WoWoUtility.getInstance().getUid(token);
		User user = userRepo.findByUid(userId);
		Event event = eventRepo.findById(eventId).get();
		Review r = new Review(user, event, review.getBody(), review.getStars(), new Date());
		Review savedReview = reviewRepo.save(r);
		event.addReview(savedReview);
		eventRepo.save(event);
		return r;
	}

	/**
	 * Prenotazione all'evento
	 * 
	 * @param eventId
	 * @param token
	 * @return booleano con l'esito
	 * @throws FirebaseAuthException
	 */
	@PostMapping("/event/{eventId}/prenote")
	public boolean prenote(@PathVariable("eventId") Long eventId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		String userId = WoWoUtility.getInstance().getUid(token);
		User user = userRepo.findByUid(userId);
		Event event = eventRepo.findById(eventId).get();
		if (event.getDate().before(new Date(System.currentTimeMillis())))
			return false;
		if (event.getPartecipants().size() == event.getMaxNumber()) {
			return false;
		}
		event.addPartecipant(user);
		user.addPartecipateEvent(event);
		abstractRepo.save(user);
		eventRepo.save(event);
		return true;
	}

	/**
	 * Cancella prenotazione
	 * 
	 * @param eventId
	 * @param token
	 * @return esisto cancellazione
	 * @throws FirebaseAuthException
	 */
	@PatchMapping("/event/{eventId}/cancelPrenote")
	public boolean cancelPrenote(@PathVariable("eventId") Long eventId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		String userId = WoWoUtility.getInstance().getUid(token);
		User user = userRepo.findByUid(userId);
		Event evento = eventRepo.findById(eventId).get();
		if (evento.getDate().before(new Date(System.currentTimeMillis())))
			return false;
		if (user.getPartecipatedEvents().contains(evento)) {
			user.removePartecipateEvent(evento);
			evento.removePartecipant(user);
			abstractRepo.save(user);
			eventRepo.save(evento);
			return true;
		}
		return false;
	}

	/**
	 * Aggiungi una foto all'evento
	 * 
	 * @param token
	 * @param file
	 * @param eventId
	 * @return Photo
	 * @throws Exception
	 */
	@PostMapping("/event/{eventId}/photo")
	public Photo addPhoto(@RequestHeader("Authorization") String token, @RequestParam("photo") MultipartFile file,
			@PathVariable("eventId") Long eventId) throws Exception {
		String userId = WoWoUtility.getInstance().getUid(token);
		if (file.isEmpty()) {
			throw new Exception("File vuoto");
		}
		try {
			// Get the file and save it somewhere
			byte[] bytes = file.getBytes();
			String url = WoWoUtility.getPhotoUrl(file.getOriginalFilename(), bytes);
			Event event = eventRepo.findById(eventId).get();
			Photo photo = new Photo(url, abstractRepo.findByUid(userId), new Date());
			Photo savedPhoto = photoRepo.save(photo);
			event.addPhoto(savedPhoto);
			eventRepo.save(event);
			return photo;
		} catch (IOException e) {
			e.printStackTrace();
		}
		// Chiamata al databse per aggiungere una foto
		return null;

	}

	/**
	 * Trova evento dal nome
	 * 
	 * @param eventName
	 * @param token
	 * @return lista di eventi con quel nome
	 * @throws FirebaseAuthException
	 */
	@GetMapping("/event/{eventName}/find")
	public List<Event> findEvent(@PathVariable("eventName") String eventName,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		WoWoUtility.getInstance().getUid(token);
		List<Event> result = eventRepo.findAll().stream().filter(event -> {
			String daCercare = eventName.toLowerCase();
			if (event.getName().toLowerCase().contains(daCercare)) {
				return true;
			}
			return false;
		}).collect(Collectors.toList());
		return result;
	}

	/**
	 * Trova l'evento in un determinato raggio a partire dalle coordinate passate
	 * 
	 * @param token
	 * @param latitude
	 * @param longitude
	 * @param raggio
	 * @return
	 */
	@GetMapping("/event/map")
	public List<Event> findEventMap(@RequestHeader("Authorization") String token,
			@RequestParam("latitude") double latitude, @RequestParam("longitude") double longitude,
			@RequestParam("raggio") int raggio) {
		List<Long> idEventi = eventRepo.findByLatAndLon(latitude, longitude, raggio);
		return eventRepo.findAllById(idEventi);
	}

}