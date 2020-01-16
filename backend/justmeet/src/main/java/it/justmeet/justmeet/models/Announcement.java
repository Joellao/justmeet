package it.justmeet.justmeet.models;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

/**
 * Responsabilità: definisce un annuncio
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */

@Entity
@Table(name = "announcements")
public class Announcement {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE)
	@Column(name = "id")
	private Long id;
	@Column(name = "name")
	private String name;
	@Column(name = "description")
	private String description;
	@Column(name = "category")
	private Category category;
	@ManyToOne(fetch = FetchType.EAGER, optional = false)
	@JoinColumn(name = "user_id", referencedColumnName = "uid", nullable = false)
	@OnDelete(action = OnDeleteAction.CASCADE)
	private AbstractUser user;
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	@OnDelete(action = OnDeleteAction.CASCADE)
	@JoinColumn(name = "announcements_comments", referencedColumnName = "id")
	private List<Comment> comments = new ArrayList<Comment>();
	@Column(name = "date")
	@Temporal(TemporalType.TIMESTAMP)
	private Date date;

	protected Announcement() {

	}

	public Announcement(String name, String description, AbstractUser user, Category categoria, Date date) {
		this.name = name;
		this.user = user;
		this.category = categoria;
		this.date = date;
		this.description = description;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getName() {
		return name;
	}

	@JsonIgnoreProperties({ "events", "friends", "announcements" })
	public AbstractUser getUser() {
		return user;
	}

	public List<Comment> getComments() {
		return comments;
	}

	public void setComments(List<Comment> comments) {
		this.comments = comments;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public boolean addComment(Comment comment) {
		return this.comments.add(comment);
	}

	public void setUser(AbstractUser user) {
		this.user = user;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}
}