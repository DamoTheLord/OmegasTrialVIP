GONT = GONT or {} -- GLOBAL OMEGA NETWORK TABLE DO NOT REMOVE
GONT.VIPTrial = {}
local cfg = GONT.VIPTrial

-------------------
--    VIPTrial   --
-- CONFIGURATION --
-------------------

cfg.ExpirySeconds = 86400 -- 24 HR = 86400

cfg.TableName = 'omega_VIPCheckHours'

cfg.ChatPrefix = '[VIPTrial]'

cfg.ChatCannotRedeem = 'You cannot redeem your VIP at this time.'

cfg.ChatVIPExpired = 'Your trial VIP has run out, please donate for further use.'

cfg.ChatRedeemVIP = 'You have redeemed your VIP!'

cfg.VIPRole = 'premium' -- HAS TO BE ULX

cfg.ReturnRole = 'user'

cfg.HoursMinimum = 1

--[[cfg.BlacklistEnabled = true
cfg.BlacklistRanks = {
    'noaccess',
}

cfg.PsCompatible = false
cfg.PsRanksNonUsers = {
    "superadmin"
}
cfg.PsPointsForNonUsers = 5500]]
