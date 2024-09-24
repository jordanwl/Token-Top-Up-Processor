# Token Top-Up Processor

This Ruby script processes user and company data from JSON files, applies token top-ups, and generates a report.

## Setup

1. Clone this repository:
   ```
   git clone https://github.com/jordanwl/token-top-up-processor.git
   cd token-top-up-processor
   ```

2. Copy your `users.json` and `companies.json` files to the `input` folder (sample files have been included).

## Running the Script

From the project root directory, run:

```
ruby challenge.rb
```

The script will:
1. Read and validate the JSON files from the `input` folder.
2. Process the data, applying token top-ups and generating a report.
3. Write the output to `output/output.txt`.

## Output

After running the script, you can find the results in `output/output.txt`. This file will contain:
- A list of companies and their users
- Token top-up information for each user
- Email status for users
- Total amount of top-ups for each company

## Running Tests

To run the test suite:

1. Install dependencies:
   ```
   bundle install
   ```

2. Run rspec:
   ```
   rspec
   ```

## Troubleshooting

If you encounter any issues:
1. Ensure your input JSON files are correctly formatted and located in the `input` folder.
2. Check that you have the necessary permissions to read from `input` and write to `output` folders.
3. Verify that you're using a compatible Ruby version (3.1+).
