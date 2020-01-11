package it.justmeet.justmeet.config;

import java.net.URL;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

import com.google.cloud.storage.Blob;
import com.google.cloud.storage.Bucket;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.google.firebase.cloud.StorageClient;

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

	public static String getPhotoUrl(String fileName, byte[] bytes) {
		Bucket bucket = StorageClient.getInstance().bucket();
		String random = UUID.randomUUID().toString();
		Blob blob = bucket.create(random.concat(fileName), bytes);
		URL url = blob.signUrl(12312312, TimeUnit.DAYS);
		return url.toString();
	}
}
