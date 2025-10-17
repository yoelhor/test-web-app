## Prepare the web app

Follow the guidance how to [deploy to Cloud Run from a GitHub repository](https://cloud.google.com/run/docs/quickstarts/deploy-continuously) and [build and deploy a .NET web app to Cloud Run](https://cloud.google.com/run/docs/quickstarts/build-and-deploy/deploy-dotnet-service). Pay attention to:

- The ingress container within an instance must listen for requests on `0.0.0.0` on the port to which requests are sent. By default, requests are sent to `8080`, but you can [configure Cloud Run](https://cloud.google.com/run/docs/configuring/services/containers#command-line) to send requests to the port of your choice.

## The .NET runtime

Cloud Run executes [container images](https://cloud.google.com/run/docs/runtimes/dotnet), so to use the .NET 9 SDK (or any unsupported .net runtime) for building your application, you need to create a custom container image using a Dockerfile that specifies the .NET 9 SDK.

The general approach is to use a multi-stage build in your Dockerfile. This is a best practice that keeps the final deployment image small by using a large SDK image only for the build process, and then switching to a smaller runtime image for the final artifact.

- https://www.youtube.com/watch?v=GAnT23KBSEI
- [Run an ASP.NET Core app in Docker containers (Microsoft)](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/docker/building-net-docker-images?view=aspnetcore-9.0)
- https://cloud.google.com/blog/products/gcp/how-to-use-docker-to-run-aspnet-core-apps-on-google-app-engine
- https://scriptbytes.io/deploy-net-core-api-to-google-cloud-run

## Build and run Docker locally

```
docker buildx build -t test-web-app .
docker run -it --rm test-web-app
```

## Appendix

List containers: 

```
docker container ls
```

Get the container ID and list file in the container:

```
docker exec f359e0be74e3 ls
```