# Stage 1: Build the application using the .NET 9 SDK image
# The .NET 9 SDK image includes the compiler, build tools, and all dependencies needed to build the app. The stage is named build.
# For more information, see https://learn.microsoft.com/aspnet/core/host-and-deploy/docker/building-net-docker-images
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Sets the working directory inside the container to /source for all subsequent instructions in this stage.
WORKDIR /source

# Copy the project files to the working directory
COPY ["source/test-web-app.csproj", "."]

# Restores the NuGet dependencies based on the project file. 
# By separating the project file copy and restore, Docker can cache this layer efficiently.
RUN dotnet restore

# Copy the rest of the application source code
COPY /source/. .

# Publish the application (this includes the build)
# -c Release is for the Release configuration
# -o /app/publish sets the output directory inside the container
RUN dotnet publish -c Release -o /app/publish --no-restore

# --- Stage 2: Create the final runtime image ---
# Use the smaller ASP.NET Core 9.0 Runtime image for deployment
# This image only contains what's needed to run the app, not the SDK
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
EXPOSE 8080
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /app/publish .

# Define the entry point to run the application
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
ENTRYPOINT ["dotnet", "test-web-app.dll"]