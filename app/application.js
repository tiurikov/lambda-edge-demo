const express = require('express')

exports.application = (port = 0) => {
   const APPLICATION = express()
   const DEMO_REGION = process.env.LAMBDA_EDGE_DEMO_REGION

   APPLICATION.get('/', (req, res) => {
      res.json({
         message: "lambda@edge demo backend is up and running in " + DEMO_REGION + " region"
      })
   })

   APPLICATION.get('/login', (req, res) => {
      const region = req.query.region
      if (region) {
         res.cookie("region", region)
         res.json({
            message: "your current region is " + region
         })
      } else {
         res.json({
            message: "please select a region to login '/login?region=XX'"
         })
      }
   })

   return APPLICATION.listen(port, () => { })
}