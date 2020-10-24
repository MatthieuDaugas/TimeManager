<template>
  <div v-if="loaded">
    Données
  </div>
  <div v-else class="no-data">
    <div class="no-data-text">
      <h1>This user has no data yet</h1>
      <div class="no-data-links">
        <router-link class="no-data-link" to="/workingtimes"
          ><span>Plan a working time</span></router-link
        >
        <router-link class="no-data-link" to="/clockmanager"
          ><span>Declare hours worked</span></router-link
        >
      </div>
    </div>
    <img src="../assets/icons/empty-office.png" alt="" />
  </div>
</template>

<script>
import axios from "axios";
import { mapState } from "vuex";

export default {
  data: function() {
    return {
      clocks: null,
      workingTimes: null,
      loaded: false
    };
  },
  computed: mapState({
    userId: state => state.userId
  }),
  created: function() {
    this.getWorkingTimes();
    this.getClocks();
  },
  methods: {
    getClocks() {
      axios
        .get(`http://localhost:4000/api/clocks/${this.userId}`)
        .then(res => {
          console.log(res);
          const clocks = res?.data?.data;
          if (clocks?.length) {
            this.clocks = [];
            for (let i = 0; i < clocks.length; i += 2) {
              const clock = { start: clocks[i].time.split("T").join(" ") };
              const nextExist = i < clocks.length - 1;
              clock.status = !nextExist;
              clock.end = nextExist
                ? clocks[i + 1].time.split("T").join(" ")
                : null;
              this.clocks.unshift(clock);
            }
            this.loaded = true;
          }
        })
        .catch(err => console.log(err));
    },
    getWorkingTimes() {
      axios
        .get(`http://localhost:4000/api/workingtimes/${this.userId}`)
        .then(res => {
          const result = res?.data?.data;
          if (result?.length) {
            this.workingTimes = result;
            this.loaded = true;
          }
        })
        .catch(err => console.log(err));
    }
  }
};
</script>

<style lang="scss">
.no-data {
  margin-top: 50px;
  .no-data-text {
    padding: 20px;
    width: 50%;
    border-radius: 3px;
    box-shadow: 0px 0 20px 0 rgba(172, 183, 213, 0.2);
    border-left: 6px solid #575366;
    margin: 0 auto;
    background-color: rgba(255, 255, 255, 0.671);
    & h1 {
      font-style: italic;
      font-weight: 100;
      font-size: 35px;
    }
    & .no-data-links {
      height: 50px;
      display: flex;
      padding-top: 12px;
      justify-content: space-around;
      & .no-data-link {
        margin: auto;
        height: 30px;
        font-weight: bold;
        display: flex;
        height: 45px;
        padding: 0 15px;
        background-color: rgba(255, 255, 255, 0);
        border-radius: 3px;
        vertical-align: middle;
        transition: .3s all ease;
        &:hover {
          background-color: rgba(108, 85, 119, 0.227);
          text-decoration: none;
        }
        & span {
          color: #575366;
          margin: auto;
        }
      }
    }
  }
  & img {
    margin-top: 20px;
    height: 562px;
    width: 900px;
  }
}
</style>