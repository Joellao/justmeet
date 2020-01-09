package it.justmeet.justmeet.exceptions;

public class WrongPasswordException extends Exception {
    private static final long serialVersionUID = 1L;

    public WrongPasswordException() {
        super();
    }

    public WrongPasswordException(String errorMessage) {
        super(errorMessage);
    }
}