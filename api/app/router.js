const rootRooter = require('express').Router();

const dataValidator = require("./services/dataValidator")
const {verifyAccessToken, isAdmin} = require('./services/jsonWebToken')
const redis = require("./services/cache")

const {
    userRoutes,
    offerRoutes,
    locationRoutes,
    messageRoutes,
    bookingRoutes,
    protectedCommentRoutes,
    publicCommentRoutes,
    authRoutes,
    adminRoutes,
    paymentRoutes
} = require('./routes');


rootRooter.use(redis, dataValidator)

rootRooter.use(authRoutes, offerRoutes, locationRoutes, publicCommentRoutes)

rootRooter.use(verifyAccessToken)
rootRooter.use([userRoutes, messageRoutes, bookingRoutes, protectedCommentRoutes, paymentRoutes])
rootRooter.use(isAdmin, adminRoutes)

module.exports = rootRooter;
