package it.justmeet.justmeet.config;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

public class WoWoUtility {
	
	private static WoWoUtility instance;

	public String getUid(String token) throws FirebaseAuthException {
		FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
		String userId = check.getUid();
		return userId;
	}

	/**
	 * @return l'unica istanza della classe
	 */
	public static WoWoUtility getInstance() {
		if (instance == null) {
			instance = new WoWoUtility();
		}
		return instance;
	}
}
