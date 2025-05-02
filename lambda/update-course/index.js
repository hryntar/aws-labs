const AWS = require("aws-sdk");

const dynamodb = new AWS.DynamoDB({
   region: process.env.DYNAMODB_REGION,
   apiVersion: "2012-08-10",
});

exports.handler = (event, context, callback) => {
   try {
      const courseData = typeof event.body === 'string' ? JSON.parse(event.body) : event.body;
      
      const pathId = event.pathParameters && event.pathParameters.id;
      const id = pathId || (courseData && courseData.id);
      
      if (!id || !courseData || !courseData.title || !courseData.watchHref || 
          !courseData.authorId || !courseData.length || !courseData.category) {
         return callback(null, {
            statusCode: 400,
            headers: {
               "Content-Type": "application/json",
               "Access-Control-Allow-Origin": "*"
            },
            body: JSON.stringify({ error: "Missing required course fields" })
         });
      }
      
      const params = {
         Item: {
            id: {
               S: id,
            },
            title: {
               S: courseData.title,
            },
            watchHref: {
               S: courseData.watchHref,
            },
            authorId: {
               S: courseData.authorId,
            },
            length: {
               S: courseData.length,
            },
            category: {
               S: courseData.category,
            },
         },
         TableName: "courses",
      };
      
      dynamodb.putItem(params, (err, data) => {
         if (err) {
            console.log(err);
            callback(null, {
               statusCode: 500,
               headers: {
                  "Content-Type": "application/json",
                  "Access-Control-Allow-Origin": "*"
               },
               body: JSON.stringify({ error: err.message })
            });
         } else {
            const updatedCourse = {
               id: params.Item.id.S,
               title: params.Item.title.S,
               watchHref: params.Item.watchHref.S,
               authorId: params.Item.authorId.S,
               length: params.Item.length.S,
               category: params.Item.category.S,
            };
            
            callback(null, {
               statusCode: 200,
               headers: {
                  "Content-Type": "application/json",
                  "Access-Control-Allow-Origin": "*"
               },
               body: JSON.stringify(updatedCourse)
            });
         }
      });
   } catch (error) {
      console.log(error);
      callback(null, {
         statusCode: 400,
         headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
         },
         body: JSON.stringify({ error: "Invalid request body" })
      });
   }
};
