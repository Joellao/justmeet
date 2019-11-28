package it.justmeet.justmeet.models;

public class Institution implements UserInterface {
    private final String name;
    private final int p_iva;
    private final String email;

    public Institution(String name, int p_iva, String email) {
        this.name = name;
        this.p_iva = p_iva;
        this.email = email;
    }

    @Override
    public void modifyProfile() {
        // TODO Auto-generated method stub

    }

    @Override
    public Event createEvent() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public boolean cancelEvent() {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public Event modifyEvent() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Comment createComment() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Comment modifyComment() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public boolean cancelComment() {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public String addPhoto() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Review createReview() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Review modifyReview() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void reportComment() {
        // TODO Auto-generated method stub

    }

    @Override
    public void reportBug() {
        // TODO Auto-generated method stub

    }

    public String getName() {
        return name;
    }

    public int getP_iva() {
        return p_iva;
    }

    public String getEmail() {
        return email;
    }

}