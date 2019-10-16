
-- In this example, we're going to map voltage to distance, using a linear 
-- approximation, according to the Sharp GP2Y0A41SK0F datasheet page 4, or 
-- Lab 3 handout page 5. 
-- 
-- The relevant points we will select are:
-- 2.750 V is  4.00 cm (or 2750 mV and  40.0 mm)
-- 0.400 V is 33.00 cm (or  400 mV and 330.0 mm)
-- 
-- Mapping to the scales in our system
-- 2750 (mV) should map to  400 (10^-4 m)
--  400 (mV) should map to 3300 (10^-4 m)
-- and developing a linear equation, we find:
--
-- Distance = -2900/2350 * Voltage + 3793.617
-- Note this code implements linear function, you must map to the 
-- NON-linear relationship in the datasheet. This code is only provided 
-- for reference to help get you started.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY voltage2distance IS
   PORT(
      clk            :  IN    STD_LOGIC;                                
      reset          :  IN    STD_LOGIC;                                
      voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);                           
      distance       :  OUT   STD_LOGIC_VECTOR(12 DOWNTO 0));  
END voltage2distance;

ARCHITECTURE behavior OF voltage2distance IS

-- This array has been pasted in from the Excel spreadsheet.
-- In this array, the values are distances, in units 10^-4 m. 
-- To get cm, move the decimal point 2 places to the left.
-- See how to get the distance output at the bottom of this file,
-- after begin.

type array_1d is array (0 to 3499) of integer;
constant v2d_LUT : array_1d := (
(4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (4000), (3999), (3993), (3987), (3981), (3974), (3968), (3962), (3956), (3949), (3943), (3937), (3931), (3924), (3918), (3912), (3906), (3899), (3893), (3887), (3881), (3874), (3868), (3862), (3856), (3849), (3843), (3837), (3831), (3824), (3818), (3812), (3806), (3799), (3793), (3787), (3781), (3774), (3768), (3762), (3756), (3749), (3743), (3737), (3731), (3724), (3718), (3712), (3706), (3699), (3693), (3687), (3681), (3674), (3668), (3662), (3656), (3649), (3643), (3637), (3631), (3624), (3618), (3612), (3606), (3599), (3593), (3587), (3581), (3574), (3568), (3562), (3556), (3549), (3543), (3537), (3531), (3524), (3518), (3512), (3506), (3498), (3478), (3458), (3438), (3418), (3398), (3378), (3358), (3338), (3318), (3298), (3278), (3258), (3238), (3218), (3198), (3178), (3158), (3138), (3118), (3098), (3078), (3058), (3038), (3018), (2999), (2995), (2991), (2986), (2982), (2978), (2973), (2969), (2965), (2960), (2956), (2952), (2947), (2943), (2939), (2934), (2930), (2926), (2921), (2917), (2913), (2908), (2904), (2899), (2895), (2891), (2886), (2882), (2878), (2873), (2869), (2865), (2860), (2856), (2852), (2847), (2843), (2839), (2834), (2830), (2826), (2821), (2817), (2812), (2808), (2804), (2799), (2795), (2791), (2786), (2782), (2778), (2773), (2769), (2765), (2760), (2756), (2752), (2747), (2743), (2739), (2734), (2730), (2726), (2721), (2717), (2712), (2708), (2704), (2699), (2695), (2691), (2686), (2682), (2678), (2673), (2669), (2665), (2660), (2656), (2652), (2647), (2643), (2639), (2634), (2630), (2625), (2621), (2617), (2612), (2608), (2604), (2599), (2595), (2591), (2586), (2582), (2578), (2573), (2569), (2565), (2560), (2556), (2552), (2547), (2543), (2538), (2534), (2530), (2525), (2521), (2517), (2512), (2508), (2504), (2499), (2496), (2492), (2488), (2484), (2480), (2476), (2472), (2469), (2465), (2461), (2457), (2453), (2449), (2446), (2442), (2438), (2434), (2430), (2426), (2422), (2419), (2415), (2411), (2407), (2403), (2399), (2396), (2392), (2388), (2384), (2380), (2376), (2372), (2369), (2365), (2361), (2357), (2353), (2349), (2346), (2342), (2338), (2334), (2330), (2326), (2322), (2319), (2315), (2311), (2307), (2303), (2299), (2296), (2292), (2288), (2284), (2280), (2276), (2272), (2269), (2265), (2261), (2257), (2253), (2249), (2246), (2242), (2238), (2234), (2230), (2226), (2222), (2219), (2215), (2211), (2207), (2203), (2199), (2195), (2192), (2188), (2184), (2180), (2176), (2172), (2169), (2165), (2161), (2157), (2153), (2149), (2145), (2142), (2138), (2134), (2130), (2126), (2122), (2119), (2115), (2111), (2107), (2103), (2099), (2095), (2092), (2088), (2084), (2080), (2076), (2072), (2069), (2065), (2061), (2057), (2053), (2049), (2045), (2042), (2038), (2034), (2030), (2026), (2022), (2019), (2015), (2011), (2007), (2003), (2000), (1997), (1995), (1992), (1990), (1987), (1985), (1982), (1980), (1977), (1975), (1972), (1970), (1967), (1965), (1962), (1960), (1957), (1955), (1952), (1950), (1947), (1945), (1942), (1940), (1937), (1935), (1932), (1930), (1927), (1925), (1922), (1920), (1917), (1915), (1912), (1910), (1907), (1905), (1902), (1900), (1897), (1895), (1892), (1890), (1887), (1885), (1882), (1880), (1877), (1874), (1872), (1869), (1867), (1864), (1862), (1859), (1857), (1854), (1852), (1849), (1847), (1844), (1842), (1839), (1837), (1834), (1832), (1829), (1827), (1824), (1822), (1819), (1817), (1814), (1812), (1809), (1807), (1804), (1802), (1799), (1797), (1794), (1791), (1789), (1786), (1783), (1781), (1778), (1775), (1773), (1770), (1767), (1764), (1762), (1759), (1756), (1754), (1751), (1748), (1746), (1743), (1740), (1738), (1735), (1732), (1730), (1727), (1724), (1721), (1719), (1716), (1713), (1711), (1708), (1705), (1703), (1700), (1697), (1695), (1692), (1689), (1687), (1684), (1681), (1678), (1676), (1673), (1670), (1668), (1665), (1662), (1660), (1657), (1654), (1652), (1649), (1646), (1644), (1641), (1638), (1635), (1633), (1630), (1627), (1625), (1622), (1619), (1617), (1614), (1611), (1609), (1606), (1603), (1601), (1598), (1595), (1592), (1590), (1587), (1585), (1583), (1581), (1580), (1578), (1576), (1575), (1573), (1571), (1569), (1568), (1566), (1564), (1563), (1561), (1559), (1558), (1556), (1554), (1553), (1551), (1549), (1548), (1546), (1544), (1543), (1541), (1539), (1538), (1536), (1534), (1532), (1531), (1529), (1527), (1526), (1524), (1522), (1521), (1519), (1517), (1516), (1514), (1512), (1511), (1509), (1507), (1506), (1504), (1502), (1500), (1499), (1497), (1495), (1494), (1492), (1490), (1489), (1487), (1485), (1484), (1482), (1480), (1479), (1477), (1475), (1474), (1472), (1470), (1469), (1467), (1465), (1463), (1462), (1460), (1458), (1457), (1455), (1453), (1452), (1450), (1448), (1447), (1445), (1443), (1442), (1440), (1438), (1437), (1435), (1433), (1432), (1430), (1428), (1426), (1425), (1423), (1421), (1420), (1418), (1416), (1415), (1413), (1411), (1410), (1408), (1406), (1405), (1403), (1401), (1400), (1398), (1397), (1395), (1393), (1392), (1390), (1389), (1387), (1386), (1384), (1383), (1381), (1380), (1378), (1377), (1375), (1373), (1372), (1370), (1369), (1367), (1366), (1364), (1363), (1361), (1360), (1358), (1357), (1355), (1353), (1352), (1350), (1349), (1347), (1346), (1344), (1343), (1341), (1340), (1338), (1337), (1335), (1333), (1332), (1330), (1329), (1327), (1326), (1324), (1323), (1321), (1320), (1318), (1316), (1315), (1313), (1312), (1310), (1309), (1307), (1306), (1304), (1303), (1301), (1300), (1298), (1296), (1295), (1293), (1292), (1290), (1289), (1287), (1286), (1284), (1283), (1281), (1280), (1278), (1276), (1275), (1273), (1272), (1270), (1269), (1267), (1266), (1264), (1263), (1261), (1260), (1258), (1256), (1255), (1253), (1252), (1250), (1249), (1247), (1246), (1244), (1243), (1241), (1240), (1238), (1236), (1235), (1233), (1232), (1230), (1229), (1227), (1226), (1224), (1223), (1221), (1220), (1218), (1216), (1215), (1213), (1212), (1210), (1209), (1207), (1206), (1204), (1203), (1201), (1200), (1199), (1198), (1197), (1196), (1196), (1195), (1194), (1193), (1192), (1191), (1191), (1190), (1189), (1188), (1187), (1186), (1186), (1185), (1184), (1183), (1182), (1181), (1181), (1180), (1179), (1178), (1177), (1176), (1176), (1175), (1174), (1173), (1172), (1171), (1171), (1170), (1169), (1168), (1167), (1166), (1166), (1165), (1164), (1163), (1162), (1161), (1161), (1160), (1159), (1158), (1157), (1156), (1156), (1155), (1154), (1153), (1152), (1151), (1151), (1150), (1149), (1148), (1147), (1146), (1146), (1145), (1144), (1143), (1142), (1141), (1141), (1140), (1139), (1138), (1137), (1136), (1136), (1135), (1134), (1133), (1132), (1131), (1131), (1130), (1129), (1128), (1127), (1126), (1126), (1125), (1124), (1123), (1122), (1121), (1121), (1120), (1119), (1118), (1117), (1116), (1116), (1115), (1114), (1113), (1112), (1111), (1111), (1110), (1109), (1108), (1107), (1106), (1106), (1105), (1104), (1103), (1102), (1101), (1101), (1100), (1099), (1098), (1097), (1096), (1096), (1095), (1094), (1093), (1092), (1091), (1091), (1090), (1089), (1088), (1087), (1086), (1086), (1085), (1084), (1083), (1082), (1081), (1081), (1080), (1079), (1078), (1077), (1076), (1076), (1075), (1074), (1073), (1072), (1071), (1071), (1070), (1069), (1068), (1067), (1066), (1066), (1065), (1064), (1063), (1062), (1061), (1061), (1060), (1059), (1058), (1057), (1056), (1056), (1055), (1054), (1053), (1052), (1051), (1051), (1050), (1049), (1048), (1047), (1046), (1046), (1045), (1044), (1043), (1042), (1041), (1041), (1040), (1039), (1038), (1037), (1036), (1036), (1035), (1034), (1033), (1032), (1031), (1031), (1030), (1029), (1028), (1027), (1026), (1026), (1025), (1024), (1023), (1022), (1021), (1021), (1020), (1019), (1018), (1017), (1016), (1016), (1015), (1014), (1013), (1012), (1011), (1011), (1010), (1009), (1008), (1007), (1006), (1006), (1005), (1004), (1003), (1002), (1001), (1001), (1000), (999), (998), (997), (996), (995), (994), (993), (992), (991), (990), (989), (988), (987), (986), (985), (984), (983), (982), (981), (980), (979), (978), (977), (976), (975), (974), (973), (972), (971), (970), (969), (968), (967), (966), (965), (964), (963), (962), (961), (960), (959), (958), (957), (956), (955), (954), (953), (952), (951), (950), (949), (948), (947), (946), (945), (944), (943), (942), (941), (940), (939), (938), (937), (936), (935), (934), (933), (932), (931), (930), (929), (928), (927), (926), (925), (924), (923), (922), (921), (920), (919), (918), (917), (916), (915), (914), (913), (912), (911), (910), (909), (908), (907), (906), (905), (904), (903), (902), (901), (900), (899), (899), (898), (898), (897), (897), (896), (896), (895), (895), (894), (894), (893), (893), (892), (892), (891), (891), (890), (890), (889), (889), (888), (887), (887), (886), (886), (885), (885), (884), (884), (883), (883), (882), (882), (881), (881), (880), (880), (879), (879), (878), (878), (877), (877), (876), (876), (875), (875), (874), (874), (873), (873), (872), (872), (871), (871), (870), (870), (869), (869), (868), (867), (867), (866), (866), (865), (865), (864), (864), (863), (863), (862), (862), (861), (861), (860), (860), (859), (859), (858), (858), (857), (857), (856), (856), (855), (855), (854), (854), (853), (853), (852), (852), (851), (851), (850), (850), (849), (848), (848), (847), (847), (846), (846), (845), (845), (844), (844), (843), (843), (842), (842), (841), (841), (840), (840), (839), (839), (838), (838), (837), (837), (836), (836), (835), (835), (834), (834), (833), (833), (832), (832), (831), (831), (830), (830), (829), (828), (828), (827), (827), (826), (826), (825), (825), (824), (824), (823), (823), (822), (822), (821), (821), (820), (820), (819), (819), (818), (818), (817), (817), (816), (816), (815), (815), (814), (814), (813), (813), (812), (812), (811), (811), (810), (810), (809), (808), (808), (807), (807), (806), (806), (805), (805), (804), (804), (803), (803), (802), (802), (801), (801), (800), (800), (799), (799), (798), (798), (797), (797), (796), (796), (795), (795), (794), (794), (793), (793), (792), (792), (791), (791), (790), (790), (789), (788), (788), (787), (787), (786), (786), (785), (785), (784), (784), (783), (783), (782), (782), (781), (781), (780), (780), (779), (779), (778), (778), (777), (777), (776), (776), (775), (775), (774), (774), (773), (773), (772), (772), (771), (771), (770), (770), (769), (768), (768), (767), (767), (766), (766), (765), (765), (764), (764), (763), (763), (762), (762), (761), (761), (760), (760), (759), (759), (758), (758), (757), (757), (756), (756), (755), (755), (754), (754), (753), (753), (752), (752), (751), (751), (750), (749), (749), (748), (748), (747), (747), (746), (746), (745), (745), (744), (744), (743), (743), (742), (742), (741), (741), (740), (740), (739), (739), (738), (738), (737), (737), (736), (736), (735), (735), (734), (734), (733), (733), (732), (732), (731), (731), (730), (729), (729), (728), (728), (727), (727), (726), (726), (725), (725), (724), (724), (723), (723), (722), (722), (721), (721), (720), (720), (719), (719), (718), (718), (717), (717), (716), (716), (715), (715), (714), (714), (713), (713), (712), (712), (711), (711), (710), (709), (709), (708), (708), (707), (707), (706), (706), (705), (705), (704), (704), (703), (703), (702), (702), (701), (701), (700), (700), (699), (699), (698), (698), (698), (697), (697), (696), (696), (695), (695), (695), (694), (694), (693), (693), (692), (692), (691), (691), (691), (690), (690), (689), (689), (688), (688), (688), (687), (687), (686), (686), (685), (685), (684), (684), (684), (683), (683), (682), (682), (681), (681), (681), (680), (680), (679), (679), (678), (678), (678), (677), (677), (676), (676), (675), (675), (674), (674), (674), (673), (673), (672), (672), (671), (671), (671), (670), (670), (669), (669), (668), (668), (667), (667), (667), (666), (666), (665), (665), (664), (664), (664), (663), (663), (662), (662), (661), (661), (660), (660), (660), (659), (659), (658), (658), (657), (657), (657), (656), (656), (655), (655), (654), (654), (653), (653), (653), (652), (652), (651), (651), (650), (650), (650), (649), (649), (648), (648), (647), (647), (646), (646), (646), (645), (645), (644), (644), (643), (643), (643), (642), (642), (641), (641), (640), (640), (639), (639), (639), (638), (638), (637), (637), (636), (636), (636), (635), (635), (634), (634), (633), (633), (633), (632), (632), (631), (631), (630), (630), (629), (629), (629), (628), (628), (627), (627), (626), (626), (626), (625), (625), (624), (624), (623), (623), (622), (622), (622), (621), (621), (620), (620), (619), (619), (619), (618), (618), (617), (617), (616), (616), (615), (615), (615), (614), (614), (613), (613), (612), (612), (612), (611), (611), (610), (610), (609), (609), (608), (608), (608), (607), (607), (606), (606), (605), (605), (605), (604), (604), (603), (603), (602), (602), (601), (601), (601), (600), (600), (600), (599), (599), (599), (598), (598), (598), (597), (597), (597), (597), (596), (596), (596), (595), (595), (595), (595), (594), (594), (594), (593), (593), (593), (592), (592), (592), (592), (591), (591), (591), (590), (590), (590), (590), (589), (589), (589), (588), (588), (588), (588), (587), (587), (587), (586), (586), (586), (585), (585), (585), (585), (584), (584), (584), (583), (583), (583), (583), (582), (582), (582), (581), (581), (581), (580), (580), (580), (580), (579), (579), (579), (578), (578), (578), (578), (577), (577), (577), (576), (576), (576), (575), (575), (575), (575), (574), (574), (574), (573), (573), (573), (573), (572), (572), (572), (571), (571), (571), (570), (570), (570), (570), (569), (569), (569), (568), (568), (568), (568), (567), (567), (567), (566), (566), (566), (566), (565), (565), (565), (564), (564), (564), (563), (563), (563), (563), (562), (562), (562), (561), (561), (561), (561), (560), (560), (560), (559), (559), (559), (558), (558), (558), (558), (557), (557), (557), (556), (556), (556), (556), (555), (555), (555), (554), (554), (554), (553), (553), (553), (553), (552), (552), (552), (551), (551), (551), (551), (550), (550), (550), (549), (549), (549), (548), (548), (548), (548), (547), (547), (547), (546), (546), (546), (546), (545), (545), (545), (544), (544), (544), (544), (543), (543), (543), (542), (542), (542), (541), (541), (541), (541), (540), (540), (540), (539), (539), (539), (539), (538), (538), (538), (537), (537), (537), (536), (536), (536), (536), (535), (535), (535), (534), (534), (534), (534), (533), (533), (533), (532), (532), (532), (531), (531), (531), (531), (530), (530), (530), (529), (529), (529), (529), (528), (528), (528), (527), (527), (527), (526), (526), (526), (526), (525), (525), (525), (524), (524), (524), (524), (523), (523), (523), (522), (522), (522), (522), (521), (521), (521), (520), (520), (520), (519), (519), (519), (519), (518), (518), (518), (517), (517), (517), (517), (516), (516), (516), (515), (515), (515), (514), (514), (514), (514), (513), (513), (513), (512), (512), (512), (512), (511), (511), (511), (510), (510), (510), (509), (509), (509), (509), (508), (508), (508), (507), (507), (507), (507), (506), (506), (506), (505), (505), (505), (504), (504), (504), (504), (503), (503), (503), (502), (502), (502), (502), (501), (501), (501), (500), (500), (500), (500), (499), (499), (499), (499), (498), (498), (498), (498), (497), (497), (497), (497), (496), (496), (496), (496), (495), (495), (495), (495), (494), (494), (494), (494), (493), (493), (493), (493), (492), (492), (492), (492), (491), (491), (491), (491), (490), (490), (490), (490), (489), (489), (489), (489), (488), (488), (488), (488), (487), (487), (487), (487), (486), (486), (486), (486), (485), (485), (485), (485), (484), (484), (484), (484), (483), (483), (483), (483), (482), (482), (482), (482), (481), (481), (481), (481), (480), (480), (480), (480), (479), (479), (479), (479), (478), (478), (478), (478), (477), (477), (477), (477), (476), (476), (476), (476), (475), (475), (475), (475), (474), (474), (474), (474), (473), (473), (473), (473), (472), (472), (472), (472), (471), (471), (471), (471), (470), (470), (470), (470), (469), (469), (469), (469), (468), (468), (468), (468), (467), (467), (467), (467), (466), (466), (466), (466), (465), (465), (465), (465), (464), (464), (464), (464), (463), (463), (463), (463), (462), (462), (462), (462), (461), (461), (461), (461), (460), (460), (460), (460), (459), (459), (459), (459), (458), (458), (458), (458), (457), (457), (457), (457), (456), (456), (456), (456), (455), (455), (455), (455), (454), (454), (454), (454), (453), (453), (453), (453), (452), (452), (452), (452), (451), (451), (451), (451), (450), (450), (450), (450), (449), (449), (449), (449), (448), (448), (448), (448), (447), (447), (447), (447), (446), (446), (446), (446), (445), (445), (445), (445), (444), (444), (444), (444), (443), (443), (443), (443), (442), (442), (442), (442), (441), (441), (441), (441), (440), (440), (440), (440), (439), (439), (439), (439), (438), (438), (438), (438), (437), (437), (437), (437), (436), (436), (436), (436), (435), (435), (435), (435), (434), (434), (434), (434), (433), (433), (433), (433), (432), (432), (432), (432), (431), (431), (431), (431), (430), (430), (430), (430), (429), (429), (429), (429), (428), (428), (428), (428), (427), (427), (427), (427), (426), (426), (426), (426), (425), (425), (425), (425), (424), (424), (424), (424), (423), (423), (423), (423), (422), (422), (422), (422), (421), (421), (421), (421), (420), (420), (420), (420), (419), (419), (419), (419), (418), (418), (418), (418), (417), (417), (417), (417), (416), (416), (416), (416), (415), (415), (415), (415), (414), (414), (414), (414), (413), (413), (413), (413), (412), (412), (412), (412), (411), (411), (411), (411), (410), (410), (410), (410), (409), (409), (409), (409), (408), (408), (408), (408), (407), (407), (407), (407), (406), (406), (406), (406), (405), (405), (405), (405), (404), (404), (404), (404), (403), (403), (403), (403), (402), (402), (402), (402), (401), (401), (401), (401), (400), (400), (400), (400), (399), (399), (399), (399), (399), (398), (398), (398), (398), (398), (397), (397), (397), (397), (397), (396), (396), (396), (396), (396), (395), (395), (395), (395), (395), (394), (394), (394), (394), (394), (393), (393), (393), (393), (393), (392), (392), (392), (392), (392), (391), (391), (391), (391), (391), (390), (390), (390), (390), (390), (389), (389), (389), (389), (389), (388), (388), (388), (388), (388), (387), (387), (387), (387), (387), (386), (386), (386), (386), (386), (385), (385), (385), (385), (385), (384), (384), (384), (384), (384), (383), (383), (383), (383), (383), (382), (382), (382), (382), (382), (381), (381), (381), (381), (381), (380), (380), (380), (380), (380), (379), (379), (379), (379), (379), (378), (378), (378), (378), (378), (377), (377), (377), (377), (377), (376), (376), (376), (376), (376), (375), (375), (375), (375), (375), (374), (374), (374), (374), (374), (373), (373), (373), (373), (373), (372), (372), (372), (372), (372), (371), (371), (371), (371), (371), (370), (370), (370), (370), (370), (369), (369), (369), (369), (369), (368), (368), (368), (368), (368), (367), (367), (367), (367), (367), (366), (366), (366), (366), (366), (365), (365), (365), (365), (365), (364), (364), (364), (364), (364), (363), (363), (363), (363), (363), (362), (362), (362), (362), (362), (361), (361), (361), (361), (361), (360), (360), (360), (360), (360), (359), (359), (359), (359), (359), (358), (358), (358), (358), (358), (357), (357), (357), (357), (357), (356), (356), (356), (356), (356), (355), (355), (355), (355), (355), (354), (354), (354), (354), (354), (353), (353), (353), (353), (353), (352), (352), (352), (352), (352), (351), (351), (351), (351), (351), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350), (350)
   -- array index 4095 (voltage = "111111111111" or 4095 mV), distance output 3787 (37.87 cm)

);

constant AllOnes : STD_LOGIC_VECTOR(12 DOWNTO 0) := "1111111111111";

begin
   -- This is the only statement required. It looks up the converted value of 
	-- the voltage input (in mV) in the v2d_LUT look-up table, and outputs the 
	-- distance (in 10^-4 m) in std_logic_vector format.
	
   process(voltage) --This process is checking if the value is in the correct bounds
	begin
		if(to_integer(unsigned(voltage)) >= 3299 or to_integer(unsigned(voltage)) <= 400) then
				distance <= AllOnes;
		else
				distance <= std_logic_vector(to_unsigned(v2d_LUT(to_integer(unsigned(voltage))),distance'length));
		end if;
	end process;

end behavior;
