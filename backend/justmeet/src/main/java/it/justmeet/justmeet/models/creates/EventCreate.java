package it.justmeet.justmeet.models.creates;

/**
 * Responsabilità: si occupa della creazione di un evento 
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */

public class EventCreate {
    private String name;
    private String location;
    private String description;
    private String date;
    private boolean isFree;
    private String category;
    private int maxPersons;

    public EventCreate(String name, String location, String description, String date, boolean isFree, String category, int maxPersons) {
        this.name = name;
        this.location = location;
        this.description=description;
        this.date = date;
        this.isFree = isFree;
        this.category = category;
        this.maxPersons = maxPersons;
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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public boolean isFree() {
        return isFree;
    }

    public void setFree(boolean isFree) {
        this.isFree = isFree;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getMaxPersons() {
        return maxPersons;
    }

    public void setMaxPersons(int maxPersons) {
        this.maxPersons = maxPersons;
    }

}