import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";
import * as logger from "firebase-functions/logger";

admin.initializeApp();

export const createUserProfile = functions.auth
  .user()
  .onCreate(async (user, _) => {
    const email = user.email;
    if (email === undefined || email === null) {
      logger.error(
        `User ${user.uid} does not have an email address. Cannot create user profile.`,
      );
      return;
    }

    if (!email.endsWith("@dksoftdealer.app")) {
      logger.info(
        `User ${user.uid} does not have an email address ending with @dksoftdealer.app.`,
      );
      return;
    }

    if (user.customClaims && user.customClaims.role === "dealer") {
      logger.info(
        `User ${user.uid} already has the role of dealer. No need to set custom claims.`,
      );
      return;
    }

    await admin
      .auth()
      .setCustomUserClaims(user.uid, { role: "dealer" })
      .then(() => {
        logger.info(`Custom claims set for user ${user.uid}.`);
      })
      .catch((error) => {
        logger.error(
          `Error setting custom claims for user ${user.uid}:`,
          error,
        );
      });
  });
