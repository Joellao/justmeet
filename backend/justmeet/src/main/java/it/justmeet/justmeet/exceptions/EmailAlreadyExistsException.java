package it.justmeet.justmeet.exceptions;

public class EmailAlreadyExistsException extends Exception {
    private static final long serialVersionUID = 1L;

    public EmailAlreadyExistsException() {
        super();
    }

    public EmailAlreadyExistsException(String errorMessage) {
        super(errorMessage);
    }
}