import Vue from "vue";
import VueRouter from "vue-router";
import User from "../components/User.vue";
import ChartManager from "../components/ChartManager.vue";
import ClockManager from "../components/ClockManager.vue";
import WorkingTime from "../components/WorkingTime.vue";
import WorkingTimes from "../components/WorkingTimes.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Home",
  },
  {
    path: "/users",
    name: "User",
    component: User
  },
  {
    path: "/workingtime",
    name: "WorkingTime",
    component: WorkingTime,
    props: (route) => {
      return {  
        workingTime: route.params.element,
        ...route.params
      }
    }
  },
  {
    path: "/workingtimes",
    name: "WorkingTimes",
    component: WorkingTimes
  },
  {
    path: "/clockmanager",
    name: "ClockManager",
    component: ClockManager
  },
  {
    path: "/chartmanager",
    name: "ChartManager",
    component: ChartManager
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

export default router;
