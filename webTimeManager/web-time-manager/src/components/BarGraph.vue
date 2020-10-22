<template>
  <div class="BarGraph">
      <bar-chart id="bar"
       data=data 
       xkey="year" 
       ykeys='["Heure théorique","Heure pratique"]' 
       bar-colors='["#FF6384","#36A2EB"]' 
       grid="true" 
       grid-text-weight="bold" 
       resize="true">
      </bar-chart>
  </div>
</template>


<script>
export default {
  data: function(){
    return {
        worked_hours,
        supposed_worked_hours
    }
  },
}
</script>