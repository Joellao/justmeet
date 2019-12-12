package it.justmeet.justmeet.models;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Table;

<<<<<<< HEAD
@Entity(name = "Institution")
@Table(name = "users")
@DiscriminatorValue("2")
public class Institution extends AbstractUser {
=======
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
    public void reportComment() {
        // TODO Auto-generated method stub

    }

    @Override
    public void reportBug() {
        // TODO Auto-generated method stub
>>>>>>> 076cf74f6bcb1f83bbb6d3bacc1b846e6ebec218

    public Institution(String uid, String name, String email) {
        super(uid, name, email);
    }

    public String getName() {
        return firstName;
    }

    public String getEmail() {
        return email;
    }

}