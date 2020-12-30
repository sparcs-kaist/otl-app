const BASE_URL = "https://otl.kaist.ac.kr/";
const MAIN_URL = BASE_URL + "main";

const SESSION_URL = "session/";
const SESSION_LOGIN_URL = SESSION_URL + "login/?next=" + MAIN_URL;
const SESSION_INFO_URL = SESSION_URL + "info";

const API_URL = "api/";
const API_SEMESTER_URL = API_URL + "semesters";
const API_COURSE_URL = API_URL + "courses";
const API_COURSE_LECTURE_URL = API_COURSE_URL + "/{id}/lectures";
const API_COURSE_REVIEW_URL = API_COURSE_URL + "/{id}/reviews";
const API_LECTURE_URL = API_URL + "lectures";
const API_LECTURE_RELATED_REVIEWS_URL =
    API_LECTURE_URL + "/{id}/related-reviews";
const API_REVIEW_URL = API_URL + "review/";
const API_REVIEW_LATEST_URL = API_REVIEW_URL + "latest/";
const API_REVIEW_INSERT_URL = API_REVIEW_URL + "insert/";
const API_REVIEW_LIKE_URL = API_REVIEW_URL + "like";

const API_TIMETABLE_URL = API_URL + "timetable/";
const API_TIMETABLE_LOAD_URL = API_TIMETABLE_URL + "table_load";
const API_TIMETABLE_CREATE_URL = API_TIMETABLE_URL + "table_create";
const API_TIMETABLE_UPDATE_URL = API_TIMETABLE_URL + "table_update";
const API_TIMETABLE_DELETE_URL = API_TIMETABLE_URL + "table_delete";
