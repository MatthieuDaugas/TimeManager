<template>
  <div class="ChartManager" style="margin-top:3%;">
    <h1>This is ChartManager page</h1>
      <BarGraph></BarGraph>
  </div>


</template>

<script>
import axios from "axios";
import BarGraph from './BarGraph'
export default {
    components: {
    BarGraph    
  },
  data: function() {
    return {
      clocks: null,
      workingTimes: null,
      userId: localStorage.getItem("userID")
    };
  },
  created: function() {
    this.getWorkingTimes();
    this.getClocks();
  },
  methods: {
    getClocks() {
      axios
        .get(`http://localhost:4000/api/clocks/${this.userId}`)
        .then(res => {
          const clocks = res?.data?.data;
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
        })
        .catch(err => console.log(err));
    },
    getWorkingTimes() {
      axios
        .get(`http://localhost:4000/api/workingtimes/${this.userId}`)
        .then(res => {
          this.workingTimes = res?.data?.data.map(_ => ({
            id: _.id,
            time: this.calcTime(_),
            start: this.formatDate(_.start),
            end: this.formatDate(_.end)
          }));
        })
        .catch(err => console.log(err));
    }
  }
};
</script>