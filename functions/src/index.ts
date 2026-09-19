import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";
import * as logger from "firebase-functions/logger";

admin.initializeApp();

// Must match AuthRepository._pseudoEmailFor's domain exactly
// (lib/features/authentication/data/auth_repository.dart). This app only
// ever creates accounts through that method, so this domain is the
// reliable signal that an account is a dealer account. Any other account
// sharing this Firebase project (created by the client app, with a
// different email/domain scheme) is treated as non-dealer by default —
// no claim is set, and AuthController.signIn rejects it at login time.
const DEALER_EMAIL_DOMAIN = "@dksoft-market.app";

export const setDealerRoleClaim = functions.auth
  .user()
  .onCreate(async (user) => {
    const email = user.email;

    if (!email || !email.endsWith(DEALER_EMAIL_DOMAIN)) {
      logger.info(
        `User ${user.uid}: email does not match the dealer domain. ` +
          "No claim set — treated as a non-dealer account.",
      );
      return;
    }

    try {
      await admin.auth().setCustomUserClaims(user.uid, { role: "dealer" });
      logger.info(`Custom claim role='dealer' set for user ${user.uid}.`);
    } catch (error) {
      logger.error(`Error setting custom claims for user ${user.uid}:`, error);
    }
  });
