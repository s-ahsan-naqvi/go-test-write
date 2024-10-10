# Go parameters
APP_NAME := hello-world-go
SRC_DIR := src
DIST_DIR := dist
GO_FILES := $(shell find $(SRC_DIR) -name '*.go')
GO_TEST_FILES := $(shell find $(SRC_DIR) -name '*_test.go')

# Create dist directory if it doesn't exist
$(DIST_DIR):
	@mkdir -p $(DIST_DIR)

# Commands
run: ## Run the Go application
	@go run $(SRC_DIR)/main.go

build: $(DIST_DIR) ## Build the Go application
	@go build -o $(DIST_DIR)/$(APP_NAME) $(SRC_DIR)/main.go

test: ## Run all tests
	@go test ./$(SRC_DIR)/...

clean: ## Remove built binaries and other generated files
	@rm -rf $(DIST_DIR)

fmt: ## Format the Go files
	@go fmt $(GO_FILES)

tidy: ## Ensure dependencies are correct (run go mod tidy)
	@cd $(SRC_DIR) && go mod tidy

lint: ## Lint the Go code (using go vet)
	@go vet ./$(SRC_DIR)/...

help: ## Show help text
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

.PHONY: run build test clean fmt tidy lint help
