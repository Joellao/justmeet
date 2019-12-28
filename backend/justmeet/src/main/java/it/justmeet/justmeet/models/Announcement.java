package it.justmeet.justmeet.models;

import java.util.ArrayList;
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
	@Column(name = "category")
	private String category;
	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "user_id", referencedColumnName = "uid", nullable = false)
	@OnDelete(action = OnDeleteAction.CASCADE)
	private AbstractUser user;
	@OneToMany(fetch = FetchType.LAZY, cascade=CascadeType.ALL)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "announcements_comments",referencedColumnName = "id")
	private List<Comment> comments = new ArrayList<Comment>();
	
	
	protected Announcement() {

	}

	public Announcement(String name, AbstractUser user, String categoria) {
		this.name = name;
		this.user = user;
		this.category = categoria;
		}

	public String getName() {
		return name;
	}

	public AbstractUser getUser() {
		return user;
	}

	public String getCategoria() {
		return category;
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

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
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
}