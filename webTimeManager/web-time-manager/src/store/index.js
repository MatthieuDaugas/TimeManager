import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    userId: null
  },
  mutations: {
    change(state, userId) {
      console.log(userId);
      state.userId = userId;
    }
  },
  actions: {
    change({ commit }, userId) {
      commit('change', userId)
    }
  },
  getters: {
    userId: state => state.userId
  }
});
