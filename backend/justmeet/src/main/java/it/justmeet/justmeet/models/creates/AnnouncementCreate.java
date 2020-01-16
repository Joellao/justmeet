package it.justmeet.justmeet.models.creates;

import it.justmeet.justmeet.models.Category;

/**
 * Responsabilità: si occupa della creazione di un annuncio
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */
public class AnnouncementCreate {
    private String name;
    private String description;
    private Category category;

    public AnnouncementCreate(String name, Category category, String description) {
        this.name = name;
        this.category = category;
        this.description=description;
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

    public void setName(String name) {
        this.name = name;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

}