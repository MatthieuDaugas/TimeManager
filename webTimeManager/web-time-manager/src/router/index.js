import Vue from "vue";
import VueRouter from "vue-router";
import about from "../views/About.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Home",
    component: about
  },
  {
    path: "/users",
    name: "User",
    component: about
  },
  {
    path: "/workingtime",
    name: "WorkingTime",
    component: about
  },
  {
    path: "/workingtimes",
    name: "WorkingTimes",
    component: about
  },
  {
    path: "/clockmanager",
    name: "ClockManager",
    component: about
  },
  {
    path: "/chartmanager",
    name: "ChartManager",
    component: about
  },
  {
    path: "/about",
    name: "About",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/About.vue")
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

export default router;
