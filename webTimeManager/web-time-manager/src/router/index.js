import Vue from "vue";
import VueRouter from "vue-router";
import ChartManager from "../components/ChartManager.vue";
import ClockManager from "../components/ClockManager.vue";
import WorkingTime from "../components/WorkingTime.vue";
import WorkingTimes from "../components/WorkingTimes.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Home",
    meta:{guest:localStorage.guest=false},

  },
  {
    path: "/workingtime",
    name: "WorkingTime",
    component: WorkingTime,
    meta:{guest:localStorage.guest=false},
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
    meta:{guest:localStorage.guest=false},

    component: WorkingTimes
    
  },
  {
    path: "/clockmanager",
    name: "ClockManager",
    meta:{guest:localStorage.guest=false},

    component: ClockManager
  },
  {
    path: "/chartmanager",
    name: "ChartManager",
    meta:{guest:localStorage.guest=false},

    component: ChartManager
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

router.beforeEach((to, from, next) => {

  if (localStorage.guest=="false") {
      // check if use already logged 
      // if true then go to home
           return next({path:'/'}); // '/' is home page for example
      // else then continue to next()
  }else {
    return next();
  }
});

export default router;
