// code from
// https://docs.aws.amazon.com/lambda/latest/dg/nodejs-handler.html
export const handler = async (event, context) => {
    console.log("EVENT: \n" + JSON.stringify(event, null, 2));
    return context.logStreamName;
};