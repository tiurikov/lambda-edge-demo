exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request
    const headers = request.headers

    if (headers.cookie) {
        for (let i = 0; i < headers.cookie.length; i++) {
            if (headers.cookie[i].value == "region=US") {
                // default 'lambda-edge-demo-eu-backend.stantiu.people.aws.dev' is replaced
                request.origin.custom.domainName = "lambda-edge-demo-us-backend.stantiu.people.aws.dev"
                break;
            }
        }
    }

    callback(null, request)
}
