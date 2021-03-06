# passport 实现微信登录

express = require "express"
router = express.Router()
passport = require "passport"
WeixinStrategy = require "passport-weixin"
AuthCtrl = require "./../ctrl/authCtrl"
authConfig = require './../config/auth.json'

opt =
	callbackURL: authConfig.web.backUrl.weixin
	requireState: false
	authorizationURL: "https://open.weixin.qq.com/connect/oauth2/authorize"
	scope: 'snsapi_userinfo'
	clientID: authConfig.auth.weixin.id
	clientSecret: authConfig.auth.weixin.key

weixinStrategy = new WeixinStrategy opt,(accessToken, refreshToken, profile, done) ->
	user =
		source:0
		token:profile.id
		nickName:profile.displayName
		headImg:profile._json.headimgurl
		sex:if profile._json.gender is 1 then 1 else 2
		remark:profile._json.openid
		unionid:profile._json.unionid
	done null,user

passport.use "weixin", weixinStrategy
router.get "/", passport.authenticate("weixin"), (req,res) ->
router.get "/callback", passport.authenticate("weixin", failureRedirect: "/login", session: false), AuthCtrl.callback

module.exports = router
