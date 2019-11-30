package it.justmeet.justmeet.models.creates;

public class ReviewCreate {
    public String body;
    public int stars;
    public String date;

    public ReviewCreate(String body, int stars, String date) {
        this.body = body;
        this.stars = stars;
        this.date = date;
    }

    public String getBody() {
        return body;
    }

    public int getStars() {
        return stars;
    }

    public String getDate() {
        return date;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public void setStars(int stars) {
        this.stars = stars;
    }

    public void setDate(String date) {
        this.date = date;
    }

}
