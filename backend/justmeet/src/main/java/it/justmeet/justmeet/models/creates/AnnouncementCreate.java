package it.justmeet.justmeet.models.creates;

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
    private String category;

    public AnnouncementCreate(String name, String category) {
        this.name = name;
        this.category = category;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

}