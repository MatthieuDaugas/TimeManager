import Vue from "vue";
import VueRouter from "vue-router";
import ChartManager from "../components/ChartManager.vue";
import ClockManager from "../components/ClockManager.vue";
import WorkingTime from "../components/WorkingTime.vue";
import WorkingTimes from "../components/WorkingTimes.vue";
import store from "../store";
Vue.use(VueRouter);

const routes = [
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
    path: "/dashboard",
    name: "ChartManager",
    component: ChartManager
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

router.beforeEach((to, from, next) => {
  if (!store?.state?.userId && to.path !== "/") {
    // check if use already logged 
    // if true then go to home
    return next({ path: '/dashboard' }); // '/' is home page for example
    // else then continue to next()
  } else {
    return next();
  }
});

export default router;
