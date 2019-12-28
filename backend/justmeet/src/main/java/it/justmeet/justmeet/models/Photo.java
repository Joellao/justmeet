package it.justmeet.justmeet.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "photos")
public class Photo {
	  	@Id
	    @GeneratedValue(strategy = GenerationType.SEQUENCE)
	    @Column(name = "id")
	    private Long id;
	    @Column(name = "url")
	    private String url;
	    @ManyToOne(fetch = FetchType.LAZY, optional = false)
	    @JoinColumn(name = "user_id", referencedColumnName = "uid", nullable = false)
	    @OnDelete(action = OnDeleteAction.CASCADE)
	    private AbstractUser user;
	    @Column(name = "date")
	    private String date;
	    @ManyToOne(fetch = FetchType.LAZY, optional = false)
	    @JoinColumn(name = "event_id", referencedColumnName = "id", nullable = false)
	    @OnDelete(action = OnDeleteAction.CASCADE)
	    private Event event;

	  protected Photo() {}
	  
	  public Photo(String url, AbstractUser user, String date, Event event) {
	        this.url=url;
	        this.user = user;
	        this.date = date;
	        this.event=event;
	    }

	public Long getId() {
			return id;
		}

		public void setId(Long id) {
			this.id = id;
		}

		public AbstractUser getUser() {
			return user;
		}

		public void setUser(AbstractUser user) {
			this.user = user;
		}

		public String getDate() {
			return date;
		}

		public void setDate(String date) {
			this.date = date;
		}

		public Event getEvent() {
			return event;
		}

		public void setEvent(Event event) {
			this.event = event;
		}

	public Photo (String url) {
		this.url=url;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

}
