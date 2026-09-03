# google_mobile_ads(play-services-ads) → WorkManager 2.7 → Room 2.2.5 순으로 딸려 오는
# Room 의 consumer 규칙은 RoomDatabase 구현 클래스만 keep 하고 기본 생성자는 남기지 않는다.
# AGP 8+ 의 R8 full mode 는 keep 된 클래스의 기본 생성자를 암묵적으로 유지하지 않아서,
# Room 이 reflection 으로 WorkDatabase_Impl 을 만들 때 InstantiationException 이 나고
# 릴리즈 빌드가 실행 직후 죽는다(androidx.startup.InitializationProvider 에서).
# 생성자까지 명시적으로 keep 한다. 디버그 빌드는 축소를 하지 않아 재현되지 않는다.
-keep class * extends androidx.room.RoomDatabase { <init>(); }
