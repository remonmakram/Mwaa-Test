insert into RAX_APP_USER.C$_0OMS_LT_SHIP_PROP_STG
(
	C1_BATCH_SHIP_PROP_KEY,
	C2_BATCH_ID,
	C3_SHIP_NODE,
	C4_SHIP_PROP_ID,
	C5_STATUS,
	C6_CREATETS,
	C7_MODIFYTS,
	C8_CREATEUSERID,
	C9_MODIFYUSERID,
	C10_CREATEPROGID,
	C11_MODIFYPROGID,
	C12_LOCKID
)
values
(
	:C1_BATCH_SHIP_PROP_KEY,
	:C2_BATCH_ID,
	:C3_SHIP_NODE,
	:C4_SHIP_PROP_ID,
	:C5_STATUS,
	:C6_CREATETS,
	:C7_MODIFYTS,
	:C8_CREATEUSERID,
	:C9_MODIFYUSERID,
	:C10_CREATEPROGID,
	:C11_MODIFYPROGID,
	:C12_LOCKIDv
)