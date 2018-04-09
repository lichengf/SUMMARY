
# android phone相关问题
---

## 1. subId, phoneId, slotId之间转换关系

	//由phoneId获取slotId
    public int getSlotId(int phoneId) {
        return SubscriptionManager.getSlotId(phoneId);
    } 

	//由slotId获取phoneId
	public int getPhoneIdBySlotId(int slotId) {
		int phoneId = SubscriptionManager.getPhoneId(getSubIdBySlot(slotId));
		DMLog.i("cfdroid", "DmykAbsTelephonyManager getPhoneIdBySlotId phoneId: " + phoneId);
		return phoneId;
	}

	//由slotId获取subId
    private int getSubIdBySlot(int slot) {
        int [] subIds = SubscriptionManager.getSubId(slot);
        int subId = ((subIds == null) ? SubscriptionManager.getDefaultSubId() : subIds[0]);
		DMLog.i("cfdroid", "DmykAbsTelephonyManager getSubIdBySlot subId: " + subId);
        return subId;
    }

	//由phoneId获取subId
	public int getSubIdByPhoneId(int phoneId) {
		int subId = SubscriptionManager.getSubIdUsingPhoneId(phoneId);
		DMLog.i("cfdroid", "DmykAbsTelephonyManager getSubIdByPhoneId subId: " + subId);
		return subId;
	}

## 2. IMEI， MEID, CellId, Lac

	//IMEI号获取
    public String getGsmDeviceId(int phoneId) {
        String result = null;
        if (phoneId >= 0 && phoneId < 2) {
            // the sole parameter of getImei is slotId
            result = getTelephonyManager().getImei(phoneId);
        }
        MLog.d("getGsmDeviceId(" + phoneId + "): " + result);
        return result;
    }

	//MEID获取
    public String getCdmaDeviceId() {
        // MTK proprietary API
        TelephonyManagerEx tme = TelephonyManagerEx.getDefault();
        // iterate over all phones to get a valid MEID
        for (int i = 0; i < getPhoneCount(); i++) {
            String result = tme.getMeid(i);
            // sanity check
            if (result != null && result.length() == LENGTH_MEID) {
                MLog.d("getCdmaDeviceId(): " + result);
                return result;
            }
        }
        MLog.d("getCdmaDeviceId(): null");
        return null;
    }

	//CellI是基站号
    public int getCellId(int phoneId) {
        int result = -1;
        if (getSubIdForSlotId(phoneId) == -1){
            MLog.d("getCellId(" + phoneId + "): " + result);
            return  result;
        }
        if (phoneId >= 0 && phoneId < 2) {
            TelephonyManagerEx tme = TelephonyManagerEx.getDefault();
            if (tme == null) {
                MLog.w("TelephonyManagerEx may not be ready");
            } else {
                // TelephonyManagerEx.getCellLocation(int) accepts slot ID
                CellLocation cl = tme.getCellLocation(phoneId);
                if (cl == null) {
                    MLog.e("CellLocation is null");
                } else if (cl instanceof GsmCellLocation) {
                    result = ((GsmCellLocation)cl).getCid();
                } else if (cl instanceof CdmaCellLocation) {
                    result = ((CdmaCellLocation)cl).getSystemId();
                } else {
                    MLog.e("CellLocation type " + cl.getClass() + " is not supported");
                }
            }
        }
        MLog.d("getCellId(" + phoneId + "): " + result);
        return result;
    }

	//Lac是小区号
    public int getLac(int phoneId) {
        int result = -1;
        if (getSubIdForSlotId(phoneId) == -1){
            MLog.d("getLac(" + phoneId + "): " + result);
            return  result;
        }
        if (phoneId >= 0 && phoneId < 2) {
            TelephonyManagerEx tme = TelephonyManagerEx.getDefault();
            if (tme == null) {
                MLog.w("TelephonyManagerEx may not be ready");
            } else {
                // TelephonyManagerEx.getCellLocation(int) accepts slot ID
                CellLocation cl = tme.getCellLocation(phoneId);
                if (cl == null) {
                    MLog.e("CellLocation is null");
                } else if (cl instanceof GsmCellLocation) {
                    result = ((GsmCellLocation)cl).getLac();
                } else if (cl instanceof CdmaCellLocation) {
                    result = ((CdmaCellLocation)cl).getNetworkId();
                } else {
                    MLog.e("CellLocation type " + cl.getClass() + " is not supported");
                }
            }
        }
        MLog.d("getLac(" + phoneId + "): " + result);
        return result;
    }

## 3. 查询Volte状态
	//
    public static final String VOLTE_DMYK_STATE_0 = "volte_dmyk_state_0";
	// 
    public static final String VOLTE_DMYK_STATE_1 = "volte_dmyk_state_1";
	//
    public static final int VOLTE_STATE_ON = 1;
	//
    public static final int VOLTE_STATE_OFF = 0;
	//
    public static final int VOLTE_STATE_UNKNOWN = -1;

    public int getVoLTEState(int phoneId) {
        int result = VOLTE_STATE_UNKNOWN;
        if (phoneId >= 0 && phoneId < 2) {
            if (!supportsMultiIms()) {
                if (phoneId == 0) {
                    boolean enabled =
                            ImsManager.isEnhanced4gLteModeSettingEnabledByUser(mContext);
                    result = enabled ? VOLTE_STATE_ON : VOLTE_STATE_OFF;
                }
            } else {
                // phoneId specified in parameter list is actually slot ID
                phoneId = SubscriptionManager.getPhoneId(getSubIdForSlotId(phoneId));
                try {
                    Method method = ImsManager.class.getDeclaredMethod(
                        "isEnhanced4gLteModeSettingEnabledByUser",
                        Context.class,
                        Integer.class);
                    boolean enabled =
                        (Boolean) method.invoke(null, new Object[]{mContext, phoneId});
                    result = enabled ? VOLTE_STATE_ON : VOLTE_STATE_OFF;
                } catch (NoSuchMethodException e1) {
                    MLog.d("No isEnhanced4gLteModeSettingEnabledByUser(Context, int)");
                       if (phoneId == 0) {
                        boolean enabled =
                            ImsManager.isEnhanced4gLteModeSettingEnabledByUser(mContext);
                        result = enabled ? VOLTE_STATE_ON : VOLTE_STATE_OFF;
                    } else {
                        result = VOLTE_STATE_UNKNOWN;
                    }
                } catch (Exception e2) {
                    e2.printStackTrace();
                    result = VOLTE_STATE_UNKNOWN;
                }
            }
        }
        MLog.d("getVoLTEState(" + phoneId + "): " + result);
        return result;
    }

## 4. 获取主卡槽位置ID

    public int getMasterPhoneId() {
        int result = SystemProperties.getInt("persist.radio.simswitch", -1) - 1;
        if (result != 0 && result != 1) {
            result = -1;
        }
        MLog.d("getMasterPhoneId(): " + result);
        return result;
    }

## 5. 获取国际漫游状态

    public boolean isInternationalNetworkRoaming(int phoneId) {
        boolean result = false;
        if (phoneId >= 0 && phoneId < 2) {
            int subId = getSubIdForSlotId(phoneId);
            if (subId >= 0) {
                // MTK proprietary API
                // getNetworkType() requires a sub ID
                result = getTelephonyManager().isNetworkRoaming(subId);
            }
        }
        MLog.d("isInternationalNetworkRoaming(" + phoneId + "): " + result);
        return result;
    }

